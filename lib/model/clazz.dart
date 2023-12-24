import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/model/user.dart';

@immutable
class Teacher {
  final String id;
  final String name;
  final String profileUrl;
  final String gender;

  const Teacher({
    required this.id,
    required this.name,
    required this.profileUrl,
    required this.gender,
  });

  factory Teacher.fromMap(Map<String, dynamic> data) {
    return Teacher(
      id: data["id"],
      name: "${data["firstName"]} ${data["lastName"]}",
      profileUrl: data["profileUrl"],
      gender: data["sex"],
    );
  }
}

@immutable
class Topic {
  final String id;
  final String name;
  final int points;
  final ({
    int quiz,
    int caseStudy,
    int materials,
  }) cost;

  const Topic({
    required this.id,
    required this.name,
    required this.points,
    required this.cost,
  });

  factory Topic.fromMap(Map<String, dynamic> data) {
    return Topic(
      id: data["id"],
      name: data["name"],
      points: int.tryParse("${data['points']}") ?? 0,
      cost: (
        quiz: data["cost"]["quiz"],
        caseStudy: data["cost"]["case_study"],
        materials: data["cost"]["materials"]??0
      ),
    );
  }
}

@immutable
class Subject {
  final String id;
  final String name;
  final String bannerImage;
  final List<Topic> topics;
  final String teacherId;

  const Subject({
    required this.id,
    required this.name,
    required this.bannerImage,
    required this.topics,
    required this.teacherId,
  });

  factory Subject.fromMap(Map<String, dynamic> data) {
    return Subject(
      id: data["id"],
      bannerImage: data["bannerImage"] ?? "",
      name: data["name"],
      topics: List.from(data["topics"]).map((e) => Topic.fromMap(e)).toList(),
      teacherId: data["teacherId"]??"",
    );
  }
}

@immutable
class ClassTopic {
  final String id;
  final bool isCompleted;
  final DateTime? completedAt;
  final String topic;

  const ClassTopic({
    required this.id,
    required this.isCompleted,
    required this.topic,
    required this.completedAt,
  });

  factory ClassTopic.fromMap(Map<String, dynamic> data) {
    return ClassTopic(
      id: data["id"],
      isCompleted: data["isCompleted"],
      topic: data["topic"],
      completedAt: data["completedAt"]?.toDate(),
    );
  }
}

@immutable
class ClassSubject {
  final String subjectId;
  final bool isCompleted;
  final List<ClassTopic> topics;
  final String teacherId;

  const ClassSubject({
    required this.subjectId,
    required this.isCompleted,
    required this.topics,
    required this.teacherId,
  });

  factory ClassSubject.fromMap(Map<String, dynamic> data, String teacherId) {
    return ClassSubject(
      subjectId: data["subjectId"],
      isCompleted: data["isCompleted"] ?? false,
      teacherId: data["teacherId"] ?? teacherId,
      topics: (data["topics"] ?? [])
          .map<ClassTopic>((e) => ClassTopic.fromMap(e))
          .toList(),
    );
  }
}

@immutable
class Classroom {
  final String id;
  final String clazz;
  final String section;
  final bool isActive;
  final String name;
  final List<ClassSubject> subjects;

  const Classroom({
    required this.id,
    required this.clazz,
    required this.section,
    required this.isActive,
    required this.name,
    required this.subjects,
  });

  factory Classroom.empty() {
    return const Classroom(
      id: "",
      name: "",
      clazz: "",
      section: "",
      isActive: false,
      subjects: [],
    );
  }

  factory Classroom.fromMap(Map<String, dynamic> data) {
    return Classroom(
      id: data["id"],
      clazz: data["clazz"],
      section: data["section"],
      isActive: data["isActive"] == true,
      name: data["name"],
      subjects: List.from(data["subjects"] ?? [])
          .map((e) => ClassSubject.fromMap(e, data["teacherId"] ?? "-"))
          .toList(),
    );
  }
}

final classroomProvider = StreamProvider((ref) {
  final baseDoc = ref.watch(schoolDocProvider);
  final user = ref.watch(profileProvider);
  print(user.value?.currentClassId);

  return baseDoc
      .collection("classes")
      .doc(user.value?.currentClassId)
      .snapshots()
      .map((event) {
    return event.exists ? Classroom.fromMap(event.data()!) : Classroom.empty();
  });
});

final classroomSubjectProvider = Provider<List<ClassSubject>>((ref) {
  final croom = ref.watch(classroomProvider);
  return croom.hasValue ? croom.value!.subjects : [];
});

final subjectListProvider = FutureProvider((ref) async {
  final baseDoc = ref.watch(schoolDocProvider);
  final cr = ref.watch(classroomProvider);

  if (cr.value?.subjects.isNotEmpty != true) return List<Subject>.from([]);

  return baseDoc
      .collection("subjects")
      .where(
        "id",
        whereIn: cr.value?.subjects.map((e) => e.subjectId),
      )
      .get()
      .then(
        (ev) => ev.docs
            .where((d) => d.exists)
            .map((d) => Subject.fromMap(d.data()))
            .toList(),
      );
});

final subjectItemProvider = Provider.autoDispose.family(
  (ref, String subjectId) {
    final classSubjects = ref.watch(classroomSubjectProvider);
    final subjectList = ref.watch(subjectListProvider);

    final csubject = classSubjects.firstWhere((e) => e.subjectId == subjectId);

    return (
      teacherId: csubject.teacherId,
      subject: subjectList.valueOrNull?.firstWhere((s) => s.id == subjectId),
      topics: csubject.topics
    );
  },
);

final teacherInfo = FutureProvider.family((ref, String teacherId) {
  final schoolDoc = ref.watch(schoolDocProvider);
  return schoolDoc
      .collection("staffs")
      .doc(teacherId)
      .get()
      .then((rec) => rec.exists ? Teacher.fromMap(rec.data()!) : null);
});
