import 'package:clarified_mobile/model/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clarified_mobile/model/school.dart';

@immutable
class LeaderItem {
  final String id;
  final String name;
  final String profileUrl;
  final ({num overall}) score;

  const LeaderItem({
    required this.id,
    required this.name,
    required this.score,
    required this.profileUrl,
  });

  factory LeaderItem.fromMap(Map<String, dynamic> d) {
    return LeaderItem(
      id: d['id'].toString(),
      name: d['name'],
      score: (overall: d["balance"]?["total"] ?? 0),
      profileUrl: d["profileUrl"],
    );
  }
}

final leaderProvider =
    StreamProvider.autoDispose.family((ref, String? classId) {
  final sdoc = ref.watch(schoolDocProvider);

  final d = sdoc.collection("students");
  return (classId?.isNotEmpty == true
          ? d.where("currentClassId", isEqualTo: classId)
          : d.where('currentClassId',whereIn: ref.read(classIDState.notifier).state))
      .orderBy(
        FieldPath.fromString("balance.total"),
        descending: true,
      )
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) {
                // print(e.id);
                return LeaderItem.fromMap(e.data());
              }
            )
            .toList(),
      );
});

Future<void> getClassId(WidgetRef ref)async{
  final baseDoc = ref.watch(schoolDocProvider);
   final profile = ref.watch(profileProvider);
  DocumentSnapshot doc = await baseDoc
      .collection("config")
      .doc("class").get();
      Map a = doc.data() as Map;
  print(doc.data());
  String classId = profile.asData?.value.currentClassId.split("_").take(2).join("_")??"";
  print(classId);
  print(a[classId]);
  List classSec = a[classId];
  classSec.forEach((element) {ref.read(classIDState.notifier).state.add(element);});
  

}




final classIDState = StateProvider<List<String>>((ref) => []);