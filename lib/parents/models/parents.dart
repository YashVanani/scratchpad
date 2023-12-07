import 'package:clarified_mobile/model/school.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ParentInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profileUrl;

  const ParentInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileUrl,
  });

  get name {
    return "$firstName $lastName";
  }

  get userId{
    return id;
  }

 

  factory ParentInfo.fromMap(Map<String, dynamic> data) {
    return ParentInfo(
      id: data['id'],
      email: data["email"] ?? "noemail-provide@platform.com",
      firstName: data["firstName"],
      lastName: data["lastName"],
      profileUrl: data["profileUrl"],
    );
  }
}

final parentProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final parentDocProvider = FutureProvider((ref) {
  final baseDoc = ref.read(schoolDocProvider);
  final parentStream = ref.watch(parentProvider);

  print(parentStream.value?.uid);
  print("HERE++");

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
