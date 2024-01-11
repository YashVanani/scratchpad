import 'dart:io';

import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/features/profile/screen/p_profile.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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

class MenuType extends Equatable  {
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
    
      @override
      List<Object?> get props => [category,label,value];
}

@immutable
class ParentSurveyInbox extends Equatable{
  final String? studentId;
  final List? inbox;
  const ParentSurveyInbox({this.inbox,this.studentId});
   factory ParentSurveyInbox.fromJson(Map<String, dynamic> json) => ParentSurveyInbox(
        inbox: ( json['inbox']??[]).cast<String>(),
        studentId: json["studentId"],
    );

    Map<String, dynamic> toJson() => {
        "studentId": studentId,
        "inbox": inbox,
    };
    factory ParentSurveyInbox.empty() {
    return const ParentSurveyInbox(
      inbox: [],
      studentId: '',
    );
  }
    
      @override
      List<Object?> get props => [inbox,studentId,];
}
@immutable
class ParentInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profileUrl;
  final List<ParentSurveyInbox?> surveyInbox;
  final List<String> childrens;
  final List<String> favoriteActivities;
  final bool inAppNotification;
  final bool appUpdateNotification;
  final String token;
  const ParentInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileUrl,
    required this.surveyInbox,
    required this.childrens,
    required this.appUpdateNotification,
    required this.inAppNotification,
    required this.favoriteActivities,
    required this.token
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
      firstName: data["firstName"]??"",
      lastName: data["lastName"]??"",
      profileUrl: data["profileUrl"]??"",
      token: data['token']??"",
      surveyInbox: data["surveyInbox"] == null ? [] : List<ParentSurveyInbox>.from(data["surveyInbox"]!.map((x) => ParentSurveyInbox.fromJson(x))),
      childrens: (data["childrens"] ?? []).cast<String>(),
      inAppNotification: data['inAppNotification']??true,
      appUpdateNotification: data['appUpdateNotification']??true,
      favoriteActivities:( data['favoriteActivities']??[]).cast<String>(),
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
            (v){
             ParentInfo parentInfo = ParentInfo.fromMap(v.data()!);
              ref.read(parentSurveyInbox.notifier).state = parentInfo.surveyInbox;
              ref.read(favoriteActivityState.notifier).state = parentInfo.favoriteActivities;
               ref.refresh(favoriteActivityProvider);
               
             return parentInfo;
            },
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

Future<void> updateParentInAppNotificationProvider (bool value, WidgetRef ref) async {
  final parentDoc = ref.watch(parentDocProvider);
  if (parentDoc.value != null) {
    await parentDoc.value!.update({
      'inAppNotification': value,    });
    ScaffoldMessenger.of(ref.read(navigatorKeyProvider).currentContext!)
        .showSnackBar(
      const SnackBar(
        content: Text("Notification status updated successfully"),
      ),
    );
  }
}



Future<void> updateParentAppUpdateNotification(bool value, WidgetRef ref)async{
   final parentDoc = ref.watch(parentDocProvider);
 await parentDoc.value!.set({
      'appUpdateNotification': value,    },SetOptions(merge: true));
      ref.watch(parentProfileProvider);
    ScaffoldMessenger.of(ref.read(navigatorKeyProvider).currentContext!)
        .showSnackBar(
      const SnackBar(
        content: Text("Notification status updated successfully"),
      ),
    );
}

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
  print("MY CHILDRENS ${profile.asData?.value?.childrens}");
  for (String i in profile.asData?.value?.childrens ?? []) {
    DocumentSnapshot data = await baseDoc.collection("students").doc(i).get();
    try{
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
        surveyInbox: [],
        inAppNotification: false,
        appUpdateNotification: false,
        token: ''
        ));
    }catch(e){
      print("ERROR ${e}");
    }
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

final studentTopicFeedbackProvider =  StreamProvider<List<Map>>((ref) {
  
  final baseDoc = ref.read(schoolDocProvider);
  print("+++STUDENT ID ${ref.read(myCurrentChild.notifier).state?.currentClassId}");
   return  baseDoc
      .collection("students")
      .doc(ref.read(myCurrentChild.notifier).state?.id).collection('topic_feedbacks').snapshots().map(
            (v) {
              print(v.docs);
              return v.docs
                .map((doc) => {...doc.data(),'id':doc.id})
                .toList();
            },
          ) ?? const Stream.empty();
});

final updatedFavoriteActivityProvider =
    FutureProvider((ref) async {
  final parentDoc = ref.watch(parentDocProvider);
  var a =ref.read(favoriteActivityState.notifier).state.length;
  print("++++++LENGTH ${a}");
  if (parentDoc.value != null) {
    await parentDoc.value!.set({
      'favoriteActivities':  ref.read(favoriteActivityState.notifier).state,    },SetOptions(merge: true));
    ScaffoldMessenger.of(ref.read(navigatorKeyProvider).currentContext!)
        .showSnackBar(
      const SnackBar(
        content: Text("Done."),
      ),
    );
  }
});

Future<void> updateParentTokenProvider (String value, WidgetRef ref) async {
  final parentDoc = ref.watch(parentDocProvider);
  if (parentDoc.value != null) {
    await parentDoc.value!.update({
      'token': value,    });
  }
}


final myCurrentReportType = StateProvider<MenuType?>((ref) => null);
final myChildClassroom = StateProvider<Classroom>((_) => Classroom.empty());
final parentSurveyInbox = StateProvider<List<ParentSurveyInbox?>>((_) => []);
final myCurrentChild = StateProvider<u.UserInfo?>((_) => null);
final selectedLanguageProvider = StateProvider<String>((_) => "English");

final previousIndexNavbarProvider = StateProvider<String>((_)=>'parent-home');
    final selectedCategoryProvider = StateProvider((String) => 'All');
  final filterProvider = StateProvider((_) => {});