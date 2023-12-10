import 'dart:convert';

import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  PostBy? postBy;
  Timestamp? postAt;
  String? content;
  String? postImage;
  int? likes;
  List<String>? likedBy;
  String id;

  Post({
    this.postBy,
    this.postAt,
    this.content,
    this.postImage,
    this.likes,
    this.likedBy,
    this.id = '',
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postBy: json["postBy"] == null ? null : PostBy.fromJson(json["postBy"]),
        postAt: json["postAt"] ?? Timestamp.now(),
        content: json["content"] ?? "",
        postImage: json["postImage"] ?? "",
        likes: json["likes"] ?? 88,
        likedBy: json["likedBy"] == null
            ? null
            : List<String>.from(json["likedBy"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "postBy": postBy?.toJson(),
        "postAt": postAt,
        "content": content,
        "postImage": postImage,
        "likes": likes,
        "likedBy":
            likedBy == null ? null : List<dynamic>.from(likedBy!.map((x) => x)),
      };
}

class PostBy {
  String? username;
  String? userAvatar;
  String? userId;

  PostBy({
    this.username,
    this.userAvatar,
    this.userId,
  });

  factory PostBy.fromJson(Map<String, dynamic> json) => PostBy(
        username: json["username"] ?? "",
        userAvatar: json["userAvatar"] ?? "",
        userId: json["userId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "userAvatar": userAvatar,
        "userId": userId,
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

  return baseDoc.collection("community");
});

final postProvider = StreamProvider<List<Post>>((ref) {
  final communityDocs = ref.watch(communityProvider);

  return communityDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Post(
                    id: doc.id,
                    postAt: doc.data()['postAt'],
                    content: doc.data()['content'],
                    postImage: doc.data()['postImage'],
                    likes: doc.data()['likes'],
                    likedBy: List<String>.from(doc.data()['likedBy']),
                    postBy: PostBy.fromJson(
                      doc.data()['postBy'],
                    )))
                .toList(),
          ) ??
      const Stream.empty();
});

Future<bool> addPost(Post post, ref) async {
  try {
    final addPostProvider = FutureProvider.autoDispose<void>((ref) async {
      final baseDoc = ref.read(schoolDocProvider);
      await baseDoc.collection("community").add(post.toJson());
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
      await baseDoc.collection("community").doc(post.id).update({
        "likes": (post.likes ?? 0) + 1,
        "likedBy": FieldValue.arrayUnion(
            [ref.read(userProvider).asData?.value?.uid.split(':').first])
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
      await baseDoc.collection("community").doc(post.id).update({
        "likes":(post.likes ?? 0)!=0? ((post.likes ?? 0) - 1):0,
        "likedBy": FieldValue.arrayRemove(
            [ref.read(userProvider).asData?.value?.uid.split(':').first])
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
      await baseDoc.collection("community").doc(post.id).delete();
    });
    await ref.watch(addPostProvider);

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}