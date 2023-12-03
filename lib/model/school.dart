import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class School {
  final String id;
  final String name;
  final String domain;
  final String isActive;
  final String logoUrl;

  const School({
    required this.id,
    required this.name,
    required this.domain,
    required this.isActive,
    required this.logoUrl,
  });

  factory School.fromMap(Map<String, dynamic> data) {
    return School(
      id: data['id'],
      name: data['name'],
      domain: data['domain'],
      isActive: data['isActive'],
      logoUrl: data['logoUrl'],
    );
  }
}

final schoolIdProvider = Provider((ref) => "vC30yCugzfDNAMgFUD01");
final schoolDocProvider = Provider((ref) {
  final schoolId = ref.watch(schoolIdProvider);

  return FirebaseFirestore.instance.doc("schools/$schoolId");
});

final schoolProvider = FutureProvider((ref) async {
  final schoolId = ref.read(schoolIdProvider);
  return FirebaseFirestore.instance
      .doc("schools/$schoolId")
      .get()
      .then((value) => School.fromMap(value.data()!));
});
