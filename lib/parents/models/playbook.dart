import 'dart:convert';

import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/features/playbook/screen/playbook_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Playbook playbookFromJson(String str) => Playbook.fromJson(json.decode(str));

String playbookToJson(Playbook data) => json.encode(data.toJson());

class Playbook {
    String? desc;
    String? action;
    String? goals;
    String? effortLevel;
    List<MaterialList>? materialList;
    String? activityMaterialDesc;
    String? title;
    bool? isActive;
    List<String>? focusAreas;
    String? activityMaterialUrl;
    String? videoUrl;
    String? domain;
    String? stages;
    String? id;
    String? categories;
    String? whyThisWorks;

    Playbook({
        this.desc,
        this.action,
        this.goals,
        this.effortLevel,
        this.materialList,
        this.activityMaterialDesc,
        this.title,
        this.isActive,
        this.focusAreas,
        this.activityMaterialUrl,
        this.videoUrl,
        this.domain,
        this.stages,
        this.id,
        this.categories,
        this.whyThisWorks
    });

    factory Playbook.fromJson(Map<String, dynamic> json) => Playbook(
        desc: json["desc"]??"",
        action: json["actions"]??"",
        goals: json["goals"]??"",
        effortLevel: json["effortLevel"]??"",
        materialList: json["materialList"] == null ? [] : List<MaterialList>.from(json["materialList"]!.map((x) => MaterialList.fromJson(x))),
        activityMaterialDesc: json["activityMaterialDesc"]??"",
        title: json["title"]??"",
        isActive: json["isActive"]??true,
        focusAreas: json["focusAreas"] == null ? [] : List<String>.from(json["focusAreas"]!.map((x) => x)),
        activityMaterialUrl: json["activityMaterialUrl"]??"",
        videoUrl: json["videoUrl"]??"",
        domain: "",
        stages: "",
        id: json["id"]??"",
        categories: json["categories"]??"",
        whyThisWorks:json['whyThisWorks']??""
    );

    Map<String, dynamic> toJson() => {
        "desc": desc,
        "action": action,
        "goals": goals,
        "effortLevel": effortLevel,
        "materialList": materialList == null ? [] : List<dynamic>.from(materialList!.map((x) => x.toJson())),
        "activityMaterialDesc": activityMaterialDesc,
        "title": title,
        "isActive": isActive,
        "focusAreas": focusAreas == null ? [] : List<dynamic>.from(focusAreas!.map((x) => x)),
        "activityMaterialUrl": activityMaterialUrl,
        "videoUrl": videoUrl,
        "domain": domain,
        "stages": stages,
        "id": id,
        "categories": categories,
        "whyThisWorks":whyThisWorks
    };
}

class MaterialList {
    String? name;
    String? id;
    String? url;

    MaterialList({
        this.name,
        this.id,
        this.url,
    });

    factory MaterialList.fromJson(Map<String, dynamic> json) => MaterialList(
        name: json["name"],
        id: json["id"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "url": url,
    };
}

final userProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final playbookColProvider = FutureProvider((ref) {
  final baseDoc = ref.read(schoolDocProvider);
  final userStream = ref.watch(userProvider);

  print(userStream.value?.uid);
  print("HERE");

  return baseDoc.collection("playbooks");
});

final playbookProvider = StreamProvider<List<Playbook>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc){
                  print(doc.id);
                  return Playbook.fromJson(doc.data());
                })
                .toList(),
          ) ??
      const Stream.empty();
});

final playbookSearchProvider = StreamProvider<List<Playbook>>((ref,) {
  final playbookDocs = ref.watch(playbookColProvider);
  final searchQuery = ref.watch(searchPlaybookState.notifier).state;
  print(searchQuery);
  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
    (v) => v.docs
        .map((doc) => Playbook.fromJson(doc.data()))
        .where((playbook) => (playbook.title??'').toLowerCase().contains(searchQuery.toLowerCase()))
        .toList(),
  ) ?? const Stream.empty();
});

final playbookCategoryProvider =StreamProvider<List<String>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()).categories??"").toSet()
                .toList(),
          ) ??
      const Stream.empty();
});

final playbookDomainProvider =StreamProvider<List<String>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()).domain??"").toSet()
                .toList(),
          ) ??
      const Stream.empty();
});

final playbookDevelopStageProvider =StreamProvider<List<String>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()).stages??"").toSet()
                .toList(),
          ) ??
      const Stream.empty();
});

final dashboardPlaybookListProvider = StreamProvider<List<Playbook>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);
  final playbookIds = ref.watch(playbookIdsState.notifier).state;

   return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
    (v) => v.docs
        .map((doc) => Playbook.fromJson(doc.data()))
        .where((playbook) => (playbookIds).contains(playbook.id))
        .toList(),
  ) ?? const Stream.empty();
});

final favoriteActivityProvider = StreamProvider<List<Playbook>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);
  final playbookIds = ref.watch(favoriteActivityState.notifier).state;
  print("++++PLAYBOOK SAVED ${playbookIds}");
   return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
    (v) => v.docs
        .map((doc) => Playbook.fromJson(doc.data()))
         .where((playbook) => (playbookIds).contains(playbook.id))
        .toList(),
  ) ?? const Stream.empty();
});
final favoriteActivityState = StateProvider<List<String>>((ref) => []);
final playbookIdsState = StateProvider<List<String>>((ref) => []);