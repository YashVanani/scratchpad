// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

import 'package:clarified_mobile/model/school.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
    List<ParentsFaq>? parentsFaq;

    FaqModel({
        this.parentsFaq,
    });

    factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        parentsFaq: json["parents-faqs"] == null ? [] : List<ParentsFaq>.from(json["parents-faqs"]!.map((x) => ParentsFaq.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "parents-faqs": parentsFaq == null ? [] : List<dynamic>.from(parentsFaq!.map((x) => x.toJson())),
    };
}

class ParentsFaq {
    String? question;
    String? answer;
    String? videoUrl;

    ParentsFaq({
        this.question,
        this.answer,
        this.videoUrl,
    });

    factory ParentsFaq.fromJson(Map<String, dynamic> json) => ParentsFaq(
        question: json["question"],
        answer: json["answer"],
        videoUrl: json["videoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
        "videoUrl": videoUrl,
    };
}

Future<FaqModel> getFaqs(WidgetRef ref)async{

  final baseDoc = ref.watch(schoolDocProvider);
  DocumentSnapshot doc = await baseDoc
      .collection("config")
      .doc("faqs")
      .get();
      print("++++++++++++++>>>${doc.data()}");
    FaqModel faqModel = FaqModel.fromJson(doc.data() as Map<String,dynamic>);
    
  return faqModel;
}