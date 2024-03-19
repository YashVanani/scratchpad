import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/features/profile/screen/p_profile.dart';
import 'package:clarified_mobile/teachers/model/playbook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class TeacherInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profileUrl;
  final List<String> surveyInbox;
  final List<String> childrens;
  final List<String> activitiesFavorites;
  final bool inAppNotification;
  final bool appUpdateNotification;
  final dynamic activityRating;
  final List<String> appliedActivities;
  final List<String> dashboardFavorites;
  final List<String> classIds;
  final bool isActive;
  final String staffId;
  const TeacherInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileUrl,
    required this.surveyInbox,
    required this.childrens,
    required this.appUpdateNotification,
    required this.inAppNotification,
    required this.activitiesFavorites,
    required this.activityRating,
    required this.appliedActivities,
    required this.dashboardFavorites,
    required this.classIds,
    required this.isActive,
    required this.staffId
  });

  get name {
    return "$firstName $lastName";
  }

  get userId {
    return id;
  }

  factory TeacherInfo.fromMap(Map<String, dynamic> data) {
    return TeacherInfo(
      id: data['id'],
      email: data["email"] ?? "noemail-provide@platform.com",
      firstName: data["firstName"],
      lastName: data["lastName"],
      profileUrl: data["profileUrl"]??"",
      surveyInbox:( data['surveyInbox']??[]).cast<String>(),
      childrens: (data["childrens"] ?? []).cast<String>(),
      inAppNotification: data['inAppNotification']??true,
      appUpdateNotification: data['appUpdateNotification']??true,
      activitiesFavorites:( data['favoriteActivities']??[]).cast<String>(),
      activityRating:data['activityRating'],
      appliedActivities:( data['appliedActivities']??[]).cast<String>(),
      dashboardFavorites: ( data['dashboardFavorites']??[]).cast<String>(),
      classIds:( data['classIds']??[]).cast<String>(),
      isActive: data['isActive']??true,
      staffId: data['id']
    );
  }
}

final teacherProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final teacherDocProvider = FutureProvider((ref) {
  final baseDoc = ref.read(schoolDocProvider);
  final teacherStream = ref.watch(teacherProvider);
  return baseDoc
      .collection("staffs")
      .doc('T0000');
});

final teacherProfileProvider = StreamProvider<TeacherInfo>((ref) {
  final teacherDoc = ref.watch(teacherDocProvider);

  return teacherDoc.value?.snapshots().where((ev) => ev.exists).map(
            (v){
              print("++++TEACHER");
             TeacherInfo teacherInfo = TeacherInfo.fromMap(v.data()!);
              ref.read(teacherSurveyInbox.notifier).state = teacherInfo.surveyInbox;
              ref.read(teacherAppliedActivityState.notifier).state = teacherInfo.appliedActivities;
              ref.read(teacherFavoriteActivityState.notifier).state = teacherInfo.activitiesFavorites;

             return teacherInfo;
            },
          ) ??
      const Stream.empty();
});

final updatedFavoriteActivityTeacherProvider =
    FutureProvider((ref) async {
  final teacherDoc = ref.watch(teacherDocProvider);
  var a =ref.read(teacherFavoriteActivityState.notifier).state.length;
  print("++++++LENGTH ${a}");
  if (teacherDoc.value != null) {
    await teacherDoc.value!.set({
      'favoriteActivities':  ref.read(teacherFavoriteActivityState.notifier).state,    },SetOptions(merge: true));
    ScaffoldMessenger.of(ref.read(navigatorKeyProvider).currentContext!)
        .showSnackBar(
      const SnackBar(
        content: Text("Done."),
      ),
    );
  }
});

Future<void> updateStudentTokenProvider (String value, WidgetRef ref) async {
  final teacherDoc = ref.watch(teacherDocProvider);
  if (teacherDoc.value != null) {
    await teacherDoc.value!.update({
      'token': value,    });
  }
}

final teacherSurveyInbox = StateProvider<List<String?>>((_) => []);