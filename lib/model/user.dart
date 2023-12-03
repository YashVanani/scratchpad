import 'package:clarified_mobile/model/school.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
