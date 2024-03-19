// To parse this JSON data, do
//
//     final teacherInfo = teacherInfoFromJson(jsonString);

import 'dart:convert';

import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// To parse this JSON data, do
//
//     final topicInfo = topicInfoFromJson(jsonString);

TopicInfo topicInfoFromJson(String str) => TopicInfo.fromJson(json.decode(str));

String topicInfoToJson(TopicInfo data) => json.encode(data.toJson());

class TopicInfo {
    String? completedAt;
    bool? isCompleted;
    String? id;
    String? topic;

    TopicInfo({
        this.completedAt,
        this.isCompleted,
        this.id,
        this.topic,
    });

    factory TopicInfo.fromJson(Map<String, dynamic> json) => TopicInfo(
        completedAt: json["completedAt"],
        isCompleted: json["isCompleted"],
        id: json["id"],
        topic: json["topic"],
    );

    Map<String, dynamic> toJson() => {
        "completedAt": completedAt,
        "isCompleted": isCompleted,
        "id": id,
        "topic": topic,
    };
}

TeacherInfo teacherInfoFromJson(String str) => TeacherInfo.fromJson(json.decode(str));

String teacherInfoToJson(TeacherInfo data) => json.encode(data.toJson());

class TeacherInfo {
    String? name;
    String? profileUrl;

    TeacherInfo({
        this.name,
        this.profileUrl,
    });

    factory TeacherInfo.fromJson(Map<String, dynamic> json) => TeacherInfo(
        name: json["name"],
        profileUrl: json["profileUrl"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "profileUrl": profileUrl,
    };
}

Future<TeacherInfo> getTeacherInfo(String id,WidgetRef ref)async{
  print("HERE IN TEACHER INFO $id");
   final schoolDoc = ref.watch(schoolDocProvider);
   DocumentSnapshot doc=await  schoolDoc
      .collection("staffs")
      .doc(id)
      .get();
      if(doc.exists){
    var data = doc.data();
    return TeacherInfo.fromJson((data as Map<String,dynamic>)??{});
    // return Classroom(clazz: data.get('clazz'), section: data?['section'], id: data?['id']);
  }else{
    return TeacherInfo(name: '',profileUrl: '');
  }
   
}

Future<Subject> getSubjectInfo(String id,WidgetRef ref)async{
  print("HERE IN TEACHER INFO $id");
   final schoolDoc = ref.watch(schoolDocProvider);
   DocumentSnapshot doc=await  schoolDoc
      .collection("subjects")
      .doc(id)
      .get();
      if(doc.exists){
    var data = doc.data();
    return Subject.fromMap((data as Map<String,dynamic>)??{});
    // return Classroom(clazz: data.get('clazz'), section: data?['section'], id: data?['id']);
  }else{
    return Subject(name: '',id: '',bannerImage: '',teacherId: '',topics: [],iconImage: '');
  }
   
}