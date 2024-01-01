import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum QuestionType {
  mcq,
  scq,
  boolean,
  slider_h,
  slider_v,
}

class SurveyAnswer {
  final String id;
  final dynamic value;
  final String label;

  const SurveyAnswer({
    required this.id,
    required this.value,
    required this.label,
  });

  factory SurveyAnswer.fromMap(Map<String, dynamic> data) {
    return SurveyAnswer(
      id: data["id"]??'',
      value: data["value"]??"",
      label: data["label"]??'',
    );
  }
}

@immutable
class SurveyQuestion {
  final String id;
  final String questionText;
  final String description;
  final QuestionType type;
  final List<SurveyAnswer> answers;
  final String? characterImg;
  final List<String> comparativeImage;

  const SurveyQuestion({
    required this.id,
    required this.questionText,
    required this.type,
    required this.description,
    required this.answers,
    required this.characterImg,
    required this.comparativeImage
  });

  factory SurveyQuestion.fromMap(Map<String, dynamic> data) {
    return SurveyQuestion(
      id: (data["id"]??"").toString(),
      questionText: data["questionText"],
      description: data["description"] ?? "",
      characterImg: data['characterImg']??'',
      type: QuestionType.values.firstWhere(
        (qt) => qt.name == data["type"],
        orElse: () => QuestionType.boolean,
      ),
      answers: (data["answers"] ?? [])
          .map<SurveyAnswer>((e) => SurveyAnswer.fromMap(e))
          .toList(),
      comparativeImage: ( data['comparative_image']??[]).cast<String>(),
    );
  }
}

@immutable
class Survey {
  final String id;
  final String name;
  final String desc;
  final int reward;
  final DateTime startAt;
  final DateTime endAt;
  final List<SurveyQuestion> questions;
  final String? thumbnail;
  final String? cardImage;
  final String? cardDesc;
  const Survey({
    required this.id,
    required this.name,
    required this.desc,
    required this.reward,
    required this.startAt,
    required this.endAt,
    required this.questions,
    required this.thumbnail,
    required this.cardImage,
    required this.cardDesc
  });

  factory Survey.fromMap(Map<String, dynamic> data) {
    return Survey(
      id: data["id"],
      name: data["name"]??"",
      desc: data["desc"]??"",
      reward: data["reward"]??0,
      startAt: (data["startAt"]??DateTime.now()).toDate(),
      endAt:( data["expiresAt"]??DateTime.now()).toDate(),
      questions: data["questions"]
          .map<SurveyQuestion>((q) => SurveyQuestion.fromMap(q))
          .toList(),
      thumbnail: data['thumbnail']??"",
      cardImage: data['card_image']??"",
      cardDesc: data['card_desc']??""
    );
  }
}

final surveyInboxProvider = StreamProvider((ref) {
  final schoolDoc = ref.watch(schoolDocProvider);
  final userProfile = ref.watch(profileProvider);

  if (userProfile.value?.surveyInbox.isNotEmpty != true) {
    return Stream<Survey?>.value(null);
  }

  return schoolDoc
      .collection("surveys")
      .where("id", whereIn: userProfile.value?.surveyInbox)
      .where("type", isEqualTo: "student")
      .where("expiresAt", isGreaterThanOrEqualTo: Timestamp.now())
      .orderBy("expiresAt")
      .orderBy("startAt")
      .limit(1)
      .snapshots()
      .map(
    (rec) {
      return rec.size != 1 ? null : Survey.fromMap(rec.docs.first.data());
    },
  );
});


final studentTopicFeedbackIdProvider =  StreamProvider<List<String>>((ref) {
    final userProfile = ref.watch(profileProvider);
  final baseDoc = ref.read(schoolDocProvider);
  return  baseDoc
      .collection("students")
      .doc(userProfile.asData?.value.id).collection('topic_feedbacks').where('status',isNotEqualTo: 'pending').snapshots().map(
            (v) {
              print(v.docs);
              return v.docs
                .map((doc) => doc.id)
                .toList();
            },
          ) ?? const Stream.empty();
});
class ProvidedAnswer {
  final dynamic answer;
  final dynamic extra;

  const ProvidedAnswer({
    required this.answer,
    required this.extra,
  });
}

final surveyAnswerSaverProvider =
    AsyncNotifierProvider.autoDispose<SurveyAnswerSaver, void>(
  SurveyAnswerSaver.new,
);

class SurveyAnswerSaver extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // The logic we previously had in our FutureProvider is now in the build method.
  }

  Future<void> saveAnswer({
    required Survey survey,
    required Map<String, ProvidedAnswer> answers,
    bool completed = false,
  }) async {
    final userProfile = ref.read(profileProvider);
    final baseDoc = ref.read(schoolDocProvider);
    final userDoc = ref.read(userDocProvider);

    final answerDoc = baseDoc
        .collection("surveys")
        .doc(survey.id)
        .collection("responses")
        .doc(userProfile.value!.id);

    final answerOpt = SetOptions(
      mergeFields: ["status", "answers", "updated_at"],
    );

    final data = {
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
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

    if (!completed) {
      return answerDoc.set(data, answerOpt);
    }

    return FirebaseFirestore.instance.runTransaction((trx) async {
      bool is24HourWent = survey.startAt.add(Duration(days: 1)).isAfter(DateTime.now());
      int reward = 0;
      try{  if(!is24HourWent){
        print("+++HALF REWARDS");
        reward = (survey.reward*0.5).toInt();
      }else{
          print("+++Full REWARDS");
        reward = survey.reward;
      }
      print("+++FINAL ${survey.reward}++ ${reward}");}
      catch(e){
        print("++++${e}}");
      }
      trx
          .set(
        answerDoc,
        data,
        answerOpt,
      )
          .update(userDoc.value!, {
        // remove this survey from their inbox, so they don't have to answer again
        "surveyInbox": FieldValue.arrayRemove([survey.id]),
        // give them some rewards
        "balance.total": FieldValue.increment(reward),
        "balance.current": FieldValue.increment(reward),
      }).set(userDoc.value!.collection("balance").doc(), {
        "type": "credit",
        "amount": reward,
        "module": "survey",
        "surveyId": survey.id
      });
    });
  }


}
