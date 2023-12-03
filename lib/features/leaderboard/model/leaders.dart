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
      id: d['id'],
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
          : d)
      .orderBy(
        FieldPath.fromString("balance.total"),
        descending: true,
      )
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => LeaderItem.fromMap(e.data()),
            )
            .toList(),
      );
});
