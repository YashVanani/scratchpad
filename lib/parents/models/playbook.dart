import 'dart:convert';

import 'package:clarified_mobile/consts/localisedModel.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/features/playbook/screen/playbook_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Playbook playbookFromJson(String str) => Playbook.fromJson(json.decode(str));

String playbookToJson(Playbook data) => json.encode(data.toJson());

class Playbook {
   LocalizedValue<String>?  desc;
    LocalizedValue<String>? action;
    LocalizedValue<String>?  goals;
    LocalizedValue<String>?  effortLevel;
    List<MaterialList>? materialList;
    String? activityMaterialDesc;
    LocalizedValue<String>?  title;
    bool? isActive;
    List<LocalizedValue<String> >? focusAreas;
    String? activityMaterialUrl;
    String? videoUrl;
    List<LocalizedValue<String> >? domain;
    List<LocalizedValue<String> >? stages;
    String? id;
    String? categories;
    LocalizedValue<String>?  whyThisWorks;
    String? type;
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
        this.whyThisWorks,
        this.type
    });

    factory Playbook.fromJson(Map<String, dynamic> json) => Playbook(
        desc: LocalizedValue.fromJson(json["desc"]??""),
        action: LocalizedValue.fromJson(json["actions"]??""),
        goals: LocalizedValue.fromJson(json["goals"]??""),
        effortLevel: LocalizedValue.fromJson(json["effortLevel"]??""),
        materialList: json["materialList"] == null ? [] : List<MaterialList>.from(json["materialList"]!.map((x) => MaterialList.fromJson(x))),
        activityMaterialDesc: json["activityMaterialDesc"]??"",
        title: LocalizedValue.fromJson(json["title"]??""),
        isActive: json["isActive"]??true,
         focusAreas: json["focusAreas"] == null ? [] : List< LocalizedValue<String>>.from(json["focusAreas"]!.map((x) => LocalizedValue<String>.fromJson(x))),
        activityMaterialUrl: json["activityMaterialUrl"]??"",
        videoUrl: json["videoUrl"]??"",
        domain: json["domain"] == null ? [] : List<LocalizedValue<String>>.from(json["domain"]!.map((x) =>  LocalizedValue<String>.fromJson(x))),
        stages: json["stages"] == null ? [] : List<LocalizedValue<String>>.from(json["stages"]!.map((x) => LocalizedValue<String>.fromJson(x))),
        id: json["id"]??"",
        categories: json["categories"]??"",
        whyThisWorks:LocalizedValue.fromJson(json['whyThisWorks']??""),
        type: json['type']??''
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
     LocalizedValue<String>? name;
    String? id;
    String? url;

    MaterialList({
        this.name,
        this.id,
        this.url,
    });

    factory MaterialList.fromJson(Map<String, dynamic> json) => MaterialList(
        name: LocalizedValue.fromJson(json["name"]),
        id: json["id"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "url": url,
    };
}
Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
    List<String>? academics;
    List<String>? sew;
    List<String>? classroomClimate;
    List<String>? LifeSkills;
    List<String>? Behaviour;

    Categories({
        this.academics,
        this.sew,
        this.classroomClimate,
        this.Behaviour,
        this.LifeSkills
    });

    factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        academics: json["Academics"] == null ? [] : List<String>.from(json["Academics"]!.map((x) => x)),
        sew: json["SEW"] == null ? [] : List<String>.from(json["SEW"]!.map((x) => x)),
        classroomClimate: json["ClassroomClimate"] == null ? [] : List<String>.from(json["ClassroomClimate"]!.map((x) => x)),
        Behaviour: json["Behaviour"] == null ? [] : List<String>.from(json["Behaviour"]!.map((x) => x)),
        LifeSkills: json["Life Skills"] == null ? [] : List<String>.from(json["Life Skills"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "Academics": academics == null ? [] : List<dynamic>.from(academics!.map((x) => x)),
        "SEW": sew == null ? [] : List<dynamic>.from(sew!.map((x) => x)),
        "Classroom Climate": classroomClimate == null ? [] : List<dynamic>.from(classroomClimate!.map((x) => x)),
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
                  if(doc.data()['type']=='parent'){
                  return Playbook.fromJson(doc.data());
                  }
                  return Playbook();
                }).where((element) => element.type=='parent')
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
        .where((playbook) => (playbook.title?.en??'').toLowerCase().contains(searchQuery.toLowerCase()))
        .toList(),
  ) ?? const Stream.empty();
});

final playbookCategoryProvider =StreamProvider<Categories>((ref) {
  try{
      final playbookDocs = ref.watch(playbookColProvider);
  final baseDoc = ref.watch(schoolDocProvider);

  return baseDoc
      .collection("config")
      .doc("playbook")
      .get().then((value){
        print(value.data());
        return Categories.fromJson(value.data()?['categories'] as Map<String, dynamic>);
      }).asStream();
      
  }catch(e){

    return  const Stream.empty();
  }
 
});

final playbookDomainProvider =StreamProvider<  List<LocalizedValue<String> >?>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()).domain??[]).expand((list) => list).toList().toSet()
                .toList(),
          ) ??
      const Stream.empty();
});

final playbookDevelopStageProvider =StreamProvider<  List<LocalizedValue<String> >>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()).stages??[]).expand((list) => list).toList().toSet()
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