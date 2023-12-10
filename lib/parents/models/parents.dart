import 'dart:io';

import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/features/profile/screen/p_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class ParentInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profileUrl;
  final List<String?> surveyInbox;

  const ParentInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileUrl,
    required this.surveyInbox,
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
      surveyInbox: (data["surveyInbox"] ?? []).cast<String?>(),
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

final updateProfileProvider = FutureProvider.family<void, ParentInfo>((ref, parentInfo) async {
  final parentDoc = ref.watch(parentDocProvider);

  if (parentDoc.value != null) {
    await parentDoc.value!.update({
      'firstName': parentInfo.firstName,
      'lastName': parentInfo.lastName,
      'email': parentInfo.email,
      'profileUrl': parentInfo.profileUrl,
    });
    ScaffoldMessenger.of(ref.read(navigatorKeyProvider).currentContext!).showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully"),
      ),
    );
  }
});

  Future<String?> uploadProfileToFirebase(XFile? postImage) async {
    if (postImage != null) {
      try {
        final String fileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        await FirebaseStorage.instance
            .ref('/profilePic')
            .child(fileName)
            .putData(File(postImage!.path).readAsBytesSync());
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
