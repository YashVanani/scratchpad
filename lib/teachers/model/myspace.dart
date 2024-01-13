// To parse this JSON data, do
//
//     final calender = calenderFromJson(jsonString);

import 'dart:convert';

import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/teachers/model/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Calender calenderFromJson(String str) => Calender.fromJson(json.decode(str));

String calenderToJson(Calender data) => json.encode(data.toJson());

class Calender {
    String id;
    String? classIds;
    String? className;
    String? dateKey;
    String? note;
    DateTime? date;
    bool? isCompleted;
    DateTime? monthKey;
    String? title;
    String? playbookId;
    String? type;

    Calender({
        required this.id,
        this.classIds,
        this.className,
        this.dateKey,
        this.note,
        this.date,
        this.isCompleted,
        this.monthKey,
        this.title,
        this.playbookId,
        this.type,
    });

    factory Calender.fromJson(Map<String, dynamic> json) => Calender(
        id: json['id']??"",
        classIds: json["classIds"]??'',
        className: json["className"]??"",
        dateKey: json["dateKey"]??"",
        note: json["note"]??"",
        date: json["date"] == null ? null : json["date"]?.toDate() ?? DateTime.timestamp(),
        isCompleted: json["isCompleted"]??false,
        monthKey: json["monthKey"] == null ? null : json["monthKey"]?.toDate() ?? DateTime.timestamp(),
        title: json["title"]??"",
        playbookId: json["playbookId"]??null,
        type: json["type"]??"",
    );

    Map<String, dynamic> toJson() => {
        "classIds": classIds,
        "className": className,
        "dateKey": dateKey,
        "note": note,
        "date": date?.toIso8601String(),
        "isCompleted": isCompleted,
        "monthKey": monthKey?.toIso8601String(),
        "title": title,
        "playbookId": playbookId,
        "type": type,
    };
}


final calenderProvider =
    StreamProvider<List<Calender>>((ref) {
  final teacherDoc = ref.watch(teacherDocProvider);
  ref.read(taskListProvider.notifier).state.clear();
  // var e = await teacherDoc.value?.collection('calendars').where('date',isGreaterThan:DateTime(ref.read(teacherCalenderDateProvider.notifier).state.year,ref.read(teacherCalenderDateProvider.notifier).state.month,ref.read(teacherCalenderDateProvider.notifier).state.day-1) ).where('date',isLessThan:DateTime(ref.read(teacherCalenderDateProvider.notifier).state.year,ref.read(teacherCalenderDateProvider.notifier).state.month,ref.read(teacherCalenderDateProvider.notifier).state.day+1)).where((ev) => ev.docs.isNotEmpty).count();
  // print("+++++>>TEST${}");
  return teacherDoc.value?.collection('calendars').where('date',isGreaterThan:DateTime(ref.read(teacherCalenderDateProvider.notifier).state.year,ref.read(teacherCalenderDateProvider.notifier).state.month,ref.read(teacherCalenderDateProvider.notifier).state.day-1) ).where('date',isLessThan:DateTime(ref.read(teacherCalenderDateProvider.notifier).state.year,ref.read(teacherCalenderDateProvider.notifier).state.month,ref.read(teacherCalenderDateProvider.notifier).state.day+1)).snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) {
                  print("+++");
                  print(doc.id);
                  if(ref.read(taskListProvider.notifier).state.where((element) => element.id==doc.id).toList().length==0){
                  ref.read(taskListProvider.notifier).state.add(Calender.fromJson({...doc.data(),"id":doc.id}));
                  }
                  return Calender.fromJson(doc.data());
                })
                .toList(),
          ) ??
       Stream.value([]);
});

Future<bool> saveTask(
    {required String classId,
    required DateTime time,
    required String message,
    required String title,
    required WidgetRef ref}) async {
  final teacherDoc = ref.watch(teacherDocProvider);
  final baseDoc = ref.read(schoolDocProvider);
  try {
    
   Classroom classroom = await baseDoc
      .collection("classes")
      .doc(classId)
      .get()
        .then((value) => Classroom.fromMap(value.data()!) );
  //     .map((event) {
  //   return event.exists ? Classroom.fromMap(event.data()!) : Classroom.empty();
  // });
   
    await teacherDoc.asData?.value.collection('calendars').doc().set({
      'classId':classId,
      'className':classroom.name,
      'date':Timestamp.fromDate(time),
      'dateKey':'${time.year}-${time.month}-${time.day}',
      'isCompleted':false,
      'monthKey':Timestamp.fromDate(time),
      'notes':message,
      'title':title,
      'type':'task'
    });
    return true;
  } catch (e) {
    return false;
  }
}

final teacherCalenderDateProvider = StateProvider<DateTime>((_) => DateTime.now());
final taskListProvider = StateProvider<List<Calender>>((ref) => []);