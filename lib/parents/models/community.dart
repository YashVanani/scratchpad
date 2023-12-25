import 'dart:convert';

import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/model/user.dart' as u;
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
    String? id;
    String? content;
    int? likeCount;
    List? likedBy;
    String? mediaUrl;
    Timestamp? postedAt;
    User? user;

    Post({
      this.id,
        this.content,
        this.likeCount,
        this.likedBy,
        this.mediaUrl,
        this.postedAt,
        this.user,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id:json['id']??"",
        content: json["content"]??"",
        likeCount: json["likeCount"]??0,
        likedBy: json["likedBy"] == null ? [] : List.from(json["likedBy"]!.map((x) => x)),
        mediaUrl: json["mediaUrl"]??"",
        postedAt: json["postedAt"]??Timestamp.now(),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "likeCount": likeCount,
        "likedBy": likedBy == null ? [] : List.from(likedBy!.map((x) => x)),
        "mediaUrl": mediaUrl,
        "postedAt": postedAt,
        "user": user?.toJson(),
    };
}

class User {
    String? name;
    String? profileUrl;
    String? userId;
    String? userType;

    User({
        this.name,
        this.profileUrl,
        this.userId,
        this.userType,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"]??'',
        profileUrl: json["profileUrl"]??'',
        userId: json["userId"]??"",
        userType: json["userType"]??"",
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "profileUrl": profileUrl,
        "userId": userId,
        "userType": userType,
    };
}
final userProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final communityProvider = FutureProvider((ref) {
  final baseDoc = ref.read(schoolDocProvider);
  final userStream = ref.watch(userProvider);

  print(userStream.value?.uid);
  print("HERE");

  return baseDoc.collection("community_posts");
});

final postProvider = StreamProvider<List<Post>>((ref) {
  final communityDocs = ref.watch(communityProvider);

  return communityDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Post(
                    id: doc.id,
                    postedAt: doc.data()['postedAt'],
                    content: doc.data()['content'],
                    mediaUrl: doc.data()['mediaUrl'],
                    likeCount: doc.data()['likeCount'],
                    likedBy:doc.data()['likedBy']??[],
                    user: User.fromJson(
                      doc.data()['user'],
                    )))
                .toList(),
          ) ??
      const Stream.empty();
});

Future<bool> addPost(Post post, ref) async {
  try {
    final addPostProvider = FutureProvider.autoDispose<void>((ref) async {
      final baseDoc = ref.read(schoolDocProvider);
      await baseDoc.collection("community_posts").add(post.toJson());
    });
    await ref.watch(addPostProvider);

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> likePost(Post post, ref) async {
  try {
    print("++++${post.id}");
    final addPostProvider = FutureProvider.autoDispose<void>((ref) async {
      final baseDoc = ref.read(schoolDocProvider);
      final parentInfo = ref.read(parentProfileProvider);
      await baseDoc.collection("community_posts").doc(post.id).update({
        "likeCount": (post.likedBy?.contains(parentInfo.asData?.value.id??"")??false)?post.likeCount:(post.likeCount ?? 0) + 1,
        "likedBy": FieldValue.arrayUnion(
            [parentInfo.asData?.value.id??""])
      });
    });
    await ref.watch(addPostProvider);

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> unLikePost(Post post, ref) async {
  try {
    print("++++${post.id}");
    final addPostProvider = FutureProvider.autoDispose<void>((ref) async {
      final baseDoc = ref.read(schoolDocProvider);
      
      final parentInfo = ref.read(parentProfileProvider);
      await baseDoc.collection("community_posts").doc(post.id).update({
        "likeCount":  (post.likedBy?.contains(parentInfo.asData?.value.id??"")??false)?(post.likeCount ?? 0) != 0 ? ((post.likeCount ?? 0) - 1) : 0:post.likeCount,
        "likedBy": FieldValue.arrayRemove(
            [parentInfo.asData?.value.id??""])
      });
    });
    await ref.watch(addPostProvider);

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> deletePost(Post post, ref) async {
  try {
    print("++++${post.id}");
    final addPostProvider = FutureProvider.autoDispose<void>((ref) async {
      final baseDoc = ref.read(schoolDocProvider);
      await baseDoc.collection("community_posts").doc(post.id).delete();
    });
    await ref.watch(addPostProvider);

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<Post?> getPostById(String id, WidgetRef ref) async {
  try {
    print("++++ID ${id}");
    final baseDoc = ref.read(schoolDocProvider);
    return await baseDoc
        .collection("community_posts")
        .doc(id)
        .get()
        .then((value) => Post.fromJson(value.data()!));
  } catch (e) {
    print("++++++++++++ERRPR ${e}");
    return null;
  }
}
final selectPostProvider =StreamProvider<Post>((ref) {

final baseDoc = ref.read(schoolDocProvider);
print("+++++${ref.read(selectedPostId.notifier).state}");
  return baseDoc
        .collection("community_posts")
        .doc(ref.read(selectedPostId.notifier).state)
        .get()
        .then((value) => Post.fromJson(value.data()!)).asStream()??
      const Stream.empty();
});

Future<ParentInfo?> getPostParent(
    String userId, String userType, WidgetRef ref) async {
  try {
    print("++++++++++GET PARENT ${userId}");
    final baseDoc = ref.read(schoolDocProvider);
    return await baseDoc
        .collection("parents")
        .doc(userId)
        .get()
        .then((value) => ParentInfo.fromMap(value.data()!));
  } catch (e) {
    null;
  }
}
Future<ParentInfo?> getPostTeacher(
    String userId, String userType, WidgetRef ref) async {
  try {
    print("++++++++++GET PARENT ${userId}");
    final baseDoc = ref.read(schoolDocProvider);
    return await baseDoc
        .collection("staffs")
        .doc(userId)
        .get()
        .then((value) => ParentInfo.fromMap(value.data()!));
  } catch (e) {
    null;
  }
}

Future<u.UserInfo?> getPostStudent(
    String userId, String userType, WidgetRef ref) async {
  try {
    final baseDoc = ref.read(schoolDocProvider);
    return await baseDoc
        .collection("students")
        .doc(userId)
        .get()
        .then((value) => u.UserInfo.fromMap(value.data()!));
  } catch (e) {
    null;
  }
}

const _kDynamicLinksUrl = 'https://clarified.page.link';
const _kAppBundleId = 'com.clarified.users';
const _kIosAppId = '6466313350';

Future<String> generateCurrentPageLink(
  BuildContext context, {
  String? id,
  String? title,
  bool isShortLink = true,
  bool forceRedirect = false,
}) async {
  try{
    final dynamicLinkParams = DynamicLinkParameters(
    link: Uri.parse('$_kDynamicLinksUrl/post/?id=$id'),
    uriPrefix: _kDynamicLinksUrl,
    androidParameters: const AndroidParameters(packageName: _kAppBundleId),
    iosParameters: const IOSParameters(
      bundleId: _kAppBundleId,
      appStoreId: _kIosAppId,
    ),
    
  );
  return isShortLink
      ? FirebaseDynamicLinks.instance
          .buildShortLink(dynamicLinkParams)
          .then((link) => link.shortUrl.toString())
      : FirebaseDynamicLinks.instance
          .buildLink(dynamicLinkParams)
          .then((link) => link.toString());
  }catch(e){
    print(e);
    return '';
  }
}

final selectedPostId = StateProvider<String>((ref) => '');