// To parse this JSON data, do
//
//     final dashboardReport = dashboardReportFromJson(jsonString);

import 'dart:convert';

import 'package:clarified_mobile/consts/localisedModel.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// To parse this JSON data, do
//
//     final studentDashboardReportModel = studentDashboardReportModelFromJson(jsonString);

import 'dart:convert';

StudentDashboardReportModel studentDashboardReportModelFromJson(String str) => StudentDashboardReportModel.fromJson(json.decode(str));

String studentDashboardReportModelToJson(StudentDashboardReportModel data) => json.encode(data.toJson());

class StudentDashboardReportModel {
    String? studentId;
    List<Recommendation>? recommendation;
    String? url;

    StudentDashboardReportModel({
        this.studentId,
        this.recommendation,
        this.url,
    });

    factory StudentDashboardReportModel.fromJson(Map<String, dynamic> json) => StudentDashboardReportModel(
        studentId: json["studentId"],
        recommendation: json["recommendation"] == null ? [] : List<Recommendation>.from(json["recommendation"]!.map((x) => Recommendation.fromJson(x))),
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "studentId": studentId,
        "recommendation": recommendation == null ? [] : List<dynamic>.from(recommendation!.map((x) => x.toJson())),
        "url": url,
    };
}

class Recommendation {
    String? id;
    LocalizedValue<String>? text;
   LocalizedValue<String>? title;

    Recommendation({
        this.id,
        this.text,
        this.title,
    });

    factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
        id: json["id"],
        text: json["text"] == null ? null : LocalizedValue.fromJson(json["title"]),
        title: json["title"] == null ? null :LocalizedValue.fromJson(json["title"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "text": text?.toJson(),
        "title": title?.toJson(),
    };
}




DashboardReport dashboardReportFromJson(String str) => DashboardReport.fromJson(json.decode(str));

String dashboardReportToJson(DashboardReport data) => json.encode(data.toJson());

class DashboardReport {
    List<String>? activities;
    String? id;
    bool? isActive;
    String? type;
    LocalizedValue<String>? title;
    String? url;
    List<Tip>? tips;
    LocalizedValue<String>? desc;
    String? imageUrl;

    DashboardReport({
        this.activities,
        this.id,
        this.isActive,
        this.type,
        this.title,
        this.url,
        this.tips,
        this.desc,
        this.imageUrl
    });

    factory DashboardReport.fromJson(Map<String, dynamic> json) => DashboardReport(
        activities: json["activities"] == null ? [] : List<String>.from(json["activities"]!.map((x) => x)),
        id: json["id"],
        isActive: json["isActive"],
        type: json["type"],
        title: LocalizedValue.fromJson(json["title"]),
        url: json["url"],
        // tips: json["tips"] == null ? [] : List<Tip>.from(json["tips"]!.map((x) => Tip.fromJson(x))),
        desc: LocalizedValue.fromJson(json["desc"]),
        imageUrl: json['imageUrl']??""
    );

    Map<String, dynamic> toJson() => {
        "activities": activities == null ? [] : List<dynamic>.from(activities!.map((x) => x)),
        "id": id,
        "isActive": isActive,
        "type": type,
        "title": title,
        "url": url,
        "tips": tips == null ? [] : List<dynamic>.from(tips!.map((x) => x.toJson())),
        "desc": desc,
        "imageUrl":imageUrl
    };
}

class Tip {
     LocalizedValue<String>? text;
    String? id;
     LocalizedValue<String>? title;

    Tip({
        this.text,
        this.id,
        this.title,
    });

    factory Tip.fromJson(Map<String, dynamic> json) => Tip(
        text: LocalizedValue.fromJson(json["text"]),
        id: json["id"],
        title: LocalizedValue.fromJson(json["title"]),
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "id": id,
        "title": title,
    };
}


Future<List<MenuType>> getReportMenuType(WidgetRef ref)async{

  final baseDoc = ref.watch(schoolDocProvider);
  DocumentSnapshot doc = await baseDoc
      .collection("config")
      .doc("dashboard")
      .get();
      print("++++++++++++++>>>${doc.data()}");
    List list = doc.get('types')??[];
    List<MenuType> menu = [];
    List<String> value = [];
    list.forEach((element) {
     
    });
    for(var i in list){
      print("+++${i['label']}");
       if(!value.contains(i['label'])){
      menu.add(MenuType.fromJson(i));
      value.add(i['label']);
      }
    }

    
  return menu.toSet().toList();
}


final reportDashboardProvider = StreamProvider((ref) {
 try{
   print("++REPORT DASHBOARD++");
  final baseDoc = ref.watch(schoolDocProvider);
  return baseDoc
      .collection("dashboards")
      .where('isActive',isEqualTo: true)
      .snapshots()
      .map((event) {
        print("***DASH**");
        print(event.docs[0].data());
     return event.docs.map((e) => DashboardReport.fromJson(e.data())).toList();
  });
 }catch(e){
  print("+++++++++ERRROR+++++++++++++++");
  print(e);
  return const Stream.empty();
 }
});

final reportDashboardProviderParent = StreamProvider((ref) {
 try{
   print("++REPORT DASHBOARD++");
  final baseDoc = ref.watch(schoolDocProvider);
  final parentDoc = ref.watch(parentDocProvider);
  final profile = ref.watch(parentProfileProvider);
   final currentChild = ref.watch(myCurrentChild);
  return baseDoc
      .collection("dashboards")
      .doc(ref.read(selectedDashboardProvider.notifier).state)
      .collection('reports')
      .doc(profile.asData?.value.id)
      .snapshots()
      .map((event) {
        List l = [];
        try{
          print((event.data()?['childrens']));
          l =event.data()?['childrens'];
        }catch(e){
          print(e);
        }
        print("898");
    Map<String, dynamic>? resultObject = getObjectByStudentId(l, currentChild?.id??"");

        print("${resultObject} =====+==");
        if(resultObject!=null){
          return StudentDashboardReportModel.fromJson(resultObject);
        }
        return event.get('url');
  });
 }catch(e){
  print("+++++++++ERRROR+++++++++++++++");
  print(e);
  return const Stream.empty();
 }
});

 Map<String, dynamic>? getObjectByStudentId(List list, String studentId) {
    for (var obj in list) {
      print('obj["studentId"]');
      if (obj["studentId"] == studentId) {
        return obj;
      }
    }
    return null;
  }

    final selectedDashboardProvider = StateProvider((String) => '');