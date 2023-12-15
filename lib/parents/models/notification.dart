// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
    String? message;
    String? type;
    String? module;
    Timestamp? createdAt;
    Notification({
        this.message,
        this.type,
        this.module,
        this.createdAt,
    });

    factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        message: json["message"]??"",
        type: json["type"]??"",
        module: json["module"]??"",
        createdAt: json["createdAt"]?? Timestamp.now(),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "type": type,
        "module": module,
        "createdAt": createdAt ?? "",
    };
}

final parentNotificationProvider =  StreamProvider<List<Notification>>((ref) {
  
  final baseDoc = ref.read(schoolDocProvider);
  final parentStream = ref.watch(parentProvider);

   return  baseDoc
      .collection("parents")
      .doc(parentStream.value?.uid.split(":").first).collection('notifications').snapshots().map(
            (v) {
              print(v.docs);
              return v.docs
                .map((doc) => Notification.fromJson(doc.data()))
                .toList();
            },
          ) ?? const Stream.empty();
});

