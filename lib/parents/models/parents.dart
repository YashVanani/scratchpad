import 'dart:io';

import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/features/profile/screen/p_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clarified_mobile/model/user.dart' as u;

// To parse this JSON data, do
//
//     final menuType = menuTypeFromJson(jsonString);

import 'dart:convert';

MenuType menuTypeFromJson(String str) => MenuType.fromJson(json.decode(str));

String menuTypeToJson(MenuType data) => json.encode(data.toJson());

class MenuType {
    String? category;
    String? label;
    String? value;

    MenuType({
        this.category,
        this.label,
        this.value,
    });

    factory MenuType.fromJson(Map<String, dynamic> json) => MenuType(
        category: json["category"],
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "category": category,
        "label": label,
        "value": value,
    };
}

@immutable
class ParentInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profileUrl;
  final List<String?> surveyInbox;
  final List<String> childrens;

  const ParentInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileUrl,
    required this.surveyInbox,
    required this.childrens,
  });

  get name {
    return "$firstName $lastName";
  }

  get userId {
    return id;
  }

  factory ParentInfo.fromMap(Map<String, dynamic> data) {
    return ParentInfo(
      id: data['id'],
      email: data["email"] ?? "noemail-provide@platform.com",
      firstName: data["firstName"],
      lastName: data["lastName"],
      profileUrl: data["profileUrl"],
      surveyInbox: (data["surveyInbox"] ?? []).cast<String?>(),
      childrens: (data["childrens"] ?? []).cast<String>(),
    );
  }
}

final parentProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final parentDocProvider = FutureProvider((ref) {
  final baseDoc = ref.read(schoolDocProvider);
  final parentStream = ref.watch(parentProvider);
  return baseDoc
      .collection("parents")
      .doc(parentStream.value?.uid.split(":").first);
});

final parentProfileProvider = StreamProvider<ParentInfo>((ref) {
  final parentDoc = ref.watch(parentDocProvider);

  return parentDoc.value?.snapshots().where((ev) => ev.exists).map(
            (v) => ParentInfo.fromMap(v.data()!),
          ) ??
      const Stream.empty();
});

final updateProfileProvider =
    FutureProvider.family<void, ParentInfo>((ref, parentInfo) async {
  final parentDoc = ref.watch(parentDocProvider);

  if (parentDoc.value != null) {
    await parentDoc.value!.update({
      'firstName': parentInfo.firstName,
      'lastName': parentInfo.lastName,
      'email': parentInfo.email,
      'profileUrl': parentInfo.profileUrl,
    });
    ScaffoldMessenger.of(ref.read(navigatorKeyProvider).currentContext!)
        .showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully"),
      ),
    );
  }
});

Future<String?> uploadProfileToFirebase(XFile? postImage) async {
  if (postImage != null) {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      await FirebaseStorage.instance
          .ref('/profilePic')
          .child(fileName)
          .putData(File(postImage.path).readAsBytesSync());
      final String downloadURL = await FirebaseStorage.instance
          .ref('/profilePic')
          .child(fileName)
          .getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}

final userListProvider = FutureProvider((ref) async {
  final baseDoc = ref.read(schoolDocProvider);
  final profile = ref.watch(parentProfileProvider);
  List user = [];
  for (String i in profile.asData?.value?.childrens ?? []) {
    DocumentSnapshot data = await baseDoc.collection("students").doc(i).get();
    user.add(u.UserInfo(
        id: data.get('id'),
        firstName: data.get('firstName'),
        lastName: data.get('lastName'),
        email: '',
        otherNames: data.get('name'),
        dateOfBirth: DateTime.now(),
        gender: '',
        currentClassId: data.get('currentClassId'),
        profileUrl: data.get('profileUrl'),
        avatar: '',
        unlockedAvatars: [],
        balance: (current: 0, spent: 0, total: 0),
        surveyInbox: []));
  }
  if(ref.read(myCurrentChild.notifier).state==null){
    ref.read(myCurrentChild.notifier).state = (user[0] as u.UserInfo);
    // ref.watch(childClassroomProvider('grade_XII_C'));
  }
  return user;
});

final childClassroomProvider = StreamProvider((ref) {

  final baseDoc = ref.watch(schoolDocProvider);
  return baseDoc
      .collection("classes")
      .doc(ref.read(myCurrentChild.notifier).state?.currentClassId)
      .snapshots()
      .map((event) {
    return event.exists ? Classroom.fromMap(event.data()!) : Classroom.empty();
  });
});

Future<Classroom> getClassroom (String id,WidgetRef ref) async {
  final baseDoc = ref.watch(schoolDocProvider);
  DocumentSnapshot doc=await  baseDoc
      .collection("classes")
      .doc(id)
      .get();
  if(doc.exists){
    var data = doc.data();
    return Classroom.fromMap((data as Map<String,dynamic>)??{});
    // return Classroom(clazz: data.get('clazz'), section: data?['section'], id: data?['id']);
  }else{
    return Classroom.empty();
  }
}



final childSubjectListProvider = FutureProvider((ref) async {
  final baseDoc = ref.watch(schoolDocProvider);
  final cr = ref.watch(childClassroomProvider);

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



final myCurrentReportType = StateProvider<MenuType?>((ref) => null);
final myChildClassroom = StateProvider<Classroom>((_) => Classroom.empty());
final myCurrentChild = StateProvider<u.UserInfo?>((_) => null);