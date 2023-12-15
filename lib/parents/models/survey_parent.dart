
import 'dart:math';

import 'package:clarified_mobile/features/home/model/entry.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
@immutable
class ParentSurvey {
  final String id;
  final String name;
  final String desc;
  final int reward;
  final DateTime startAt;
  final DateTime endAt;
  final List<SurveyQuestion> questions;
  final List<String> purpose;
  final String imageUrl;
  const ParentSurvey({
    required this.id,
    required this.name,
    required this.desc,
    required this.reward,
    required this.startAt,
    required this.endAt,
    required this.questions,
    required this.purpose,
    required this.imageUrl
  });

  factory ParentSurvey.fromMap(Map<String, dynamic> data) {
    return ParentSurvey(
      id: data["id"],
      name: data["name"]??"",
      desc: data["desc"]??"",
      reward: data["reward"]??0,
      startAt: (data["startAt"]??DateTime.now()).toDate(),
      endAt:( data["expiresAt"]??DateTime.now()).toDate(),
      questions: data["questions"]
          .map<SurveyQuestion>((q) => SurveyQuestion.fromMap(q))
          .toList(),
      purpose: (data["purpose"]??[]).cast<String>(),
      imageUrl: data['imageUrl']??"",
    );
  }
}

final surveyInboxParentProvider = StreamProvider((ref) {
  final schoolDoc = ref.watch(schoolDocProvider);
  final userProfile = ref.watch(parentProfileProvider);

  if (userProfile.value?.surveyInbox.isNotEmpty != true) {
    return Stream<ParentSurvey?>.value(null);
  }

  return schoolDoc
      .collection("parent_survey")
      .where("id", whereIn: userProfile.value?.surveyInbox)
      .where("type", isEqualTo: "parent")
      .where("expiresAt", isGreaterThanOrEqualTo: Timestamp.now())
      .orderBy("expiresAt")
      .orderBy("startAt")
      .limit(1)
      .snapshots()
      .map(
    (rec) {
      // print(rec.docChanges.first.doc.data());
      return rec.size != 1 ? null : ParentSurvey.fromMap(rec.docs.first.data());
    },
  );
});

class ProvidedAnswerParent {
  final dynamic answer;
  final dynamic extra;

  const ProvidedAnswerParent({
    required this.answer,
    required this.extra,
  });
}

final surveyAnswerSaverParentProviderParent =
    AsyncNotifierProvider.autoDispose<SurveyAnswerSaverParent, void>(
  SurveyAnswerSaverParent.new,
);

class SurveyAnswerSaverParent extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // The logic we previously had in our FutureProvider is now in the build method.
  }

  Future<void> saveAnswer({
    required ParentSurvey survey,
    required Map<String, ProvidedAnswerParent> answers,
    bool completed = false,
  }) async {
   try{
    print("ANSWER ++ ${answers.entries.map((e) => {e.key,e.value.answer})})}");
 final userProfile = ref.read(parentProfileProvider);
    final baseDoc = ref.read(schoolDocProvider);
    final userDoc = ref.read(parentDocProvider);
    final currentChild = ref.read(myCurrentChild);
    final answerDoc = baseDoc
        .collection("parent_survey")
        .doc(survey.id)
        .collection("responses")
        .doc(userProfile.value!.id);

    final answerOpt = SetOptions(
      mergeFields: ["status", "answers", "updated_at"],
    );

    final data = {
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
      "student_id": currentChild?.id??"",
      "status": completed ? "submitted" : "pending",
      "answers": Map.fromEntries(
        answers.entries.map(
          (e) => MapEntry(e.key, {
            "answer": e.value.answer,
            "data": e.value.extra,
          }),
        ),
      ),
    };
    print("+DATA ${data}");

    if (!completed) {
      print("+AAASSA");
      return answerDoc.set(data, answerOpt);
    }

      print("+AAASSaaaaaasqqqqA ${answerDoc}");
    return FirebaseFirestore.instance.runTransaction((trx) async {
     trx.set(answerDoc, data, answerOpt).update(userDoc.value!, {
        "surveyInbox": FieldValue.arrayRemove([survey.id]),
      });
    }).catchError((e){
      print("+++++++++++++>>>${e}");
    });
  
   }catch(e){
    print("+__+__+__+__++_+");
     print(e);
   }
   
  }
  
  }
