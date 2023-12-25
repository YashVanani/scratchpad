import 'package:clarified_mobile/features/notification/screen/notification_setting.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/features/profile/screen/p_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clarified_mobile/parents/models/notification.dart' as n;
@immutable
class UserInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String otherNames;
  final DateTime dateOfBirth;
  final String gender;
  final String currentClassId;
  final String profileUrl;
  final String? avatar;
  final List<String> unlockedAvatars;
  final List<String> surveyInbox;
  
  final bool inAppNotification;
  final bool appUpdateNotification;
  final ({int current, int spent, int total}) balance;

  const UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.otherNames,
    required this.dateOfBirth,
    required this.gender,
    required this.currentClassId,
    required this.profileUrl,
    required this.avatar,
    required this.unlockedAvatars,
    required this.balance,
    required this.surveyInbox,
    required this.appUpdateNotification,
    required this.inAppNotification
  });

  get name {
    return "$firstName $lastName";
  }

  get xpBalance {
    return balance.total - balance.spent;
  }

  factory UserInfo.fromMap(Map<String, dynamic> data) {
    return UserInfo(
      id: data['id'],
      email: data["email"] ?? "noemail-provide@platform.com",
      firstName: data["firstName"],
      lastName: data["lastName"],
      otherNames: data["otherNames"] ?? "",
      dateOfBirth: data["dateOfBirth"]?.toDate() ?? DateTime.timestamp(),
      gender: data["gender"],
      currentClassId: data["currentClassId"],
      profileUrl: data["profileUrl"],
      avatar: data["avatar"],
      surveyInbox: List.from(data["surveyInbox"] ?? []),
      unlockedAvatars: List.from(data["unlockedAvatars"] ?? []),
      balance: (
        current: data['balance']['current'],
        total: data['balance']['total'],
        spent: data['balance']['spent']
      ),
      appUpdateNotification: data['appUpdateNotification']??true,
      inAppNotification: data['inAppNotification']??true
    );
  }
}

final userProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final userDocProvider = FutureProvider((ref) {
  final baseDoc = ref.read(schoolDocProvider);
  final userStream = ref.watch(userProvider);

  print(userStream.value?.uid);
  print("HERE");

  return baseDoc
      .collection("students")
      .doc(userStream.value?.uid.split(":").first);
});

final profileProvider = StreamProvider<UserInfo>((ref) {
  final userDoc = ref.watch(userDocProvider);

  return userDoc.value?.snapshots().where((ev) => ev.exists).map(
            (v) => UserInfo.fromMap(v.data()!),
          ) ??
      const Stream.empty();
});


final studentNotificationProvider =  StreamProvider<List<n.Notification>>((ref) {
  
  final baseDoc = ref.read(schoolDocProvider);
  final parentStream = ref.watch(profileProvider);

   return  baseDoc
      .collection("students")
      .doc(parentStream.asData?.value.id.split(":").first).collection('notifications').snapshots().map(
            (v) {
              print(v.docs);
              return v.docs
                .map((doc) => n.Notification.fromJson(doc.data()))
                .toList();
            },
          ) ?? const Stream.empty();
});

Future<void> updateStudentInAppNotificationProvider (bool value, WidgetRef ref) async {
  final parentDoc = ref.watch(userDocProvider);
  if (parentDoc.value != null) {
    await parentDoc.value!.update({
      'inAppNotification': value,    });
    ScaffoldMessenger.of(ref.read(studentKeyProvider).currentContext!)
        .showSnackBar(
      const SnackBar(
        content: Text("Notification status updated successfully"),
      ),
    );
  }
}



Future<void> updateStudentAppUpdateNotification(bool value, WidgetRef ref)async{
    final parentDoc = ref.watch(userDocProvider);
 await parentDoc.value!.set({
      'appUpdateNotification': value,    },SetOptions(merge: true,),);
      ref.watch(profileProvider);
    ScaffoldMessenger.of(ref.read(studentKeyProvider).currentContext!)
        .showSnackBar(
      const SnackBar(
        content: Text("Notification status updated successfully"),
      ),
    );
}
