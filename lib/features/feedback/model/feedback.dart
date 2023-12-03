import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum QuestionType {
  mcq,
  scq,
  boolean,
  boolean_with_comment,
  sliding,
}

@immutable
class FeedbackQuestion {
  final String id;
  final QuestionType type;
  final String note;
  final String questionText;
  final List<String> answers;

  const FeedbackQuestion({
    required this.id,
    required this.type,
    required this.note,
    required this.questionText,
    required this.answers,
  });

  factory FeedbackQuestion.fromMap(Map<String, dynamic> data) {
    return FeedbackQuestion(
      id: data['id'],
      type: QuestionType.values.firstWhere((e) => e.name == data['type']),
      note: data['note'] ?? "",
      questionText: data['questionText'],
      answers: List<String>.from(data['asnwers'] ?? []),
    );
  }
}

@immutable
class Feedback {
  final String id;
  final String content;
  final List<FeedbackQuestion> questions;

  const Feedback({
    required this.id,
    required this.content,
    required this.questions,
  });

  factory Feedback.fromMap(Map<String, dynamic> data) {
    int idx = 0;
    return Feedback(
      id: data['id'],
      content: data['instructions'] ?? "--Failed---",
      questions: List.from(data['questions'])
          .map((e) => FeedbackQuestion.fromMap({
                ...e,
                "id": e['id'] ??
                    "${DateTime.now().millisecondsSinceEpoch}:${idx++}"
              }))
          .toList(),
    );
  }
}

final feedbackQuestionProvider = FutureProvider.autoDispose
    .family((ref, ({String subjectId, String topicId}) rec) {
  final schoolDoc = ref.read(schoolDocProvider);

  return schoolDoc
      .collection('subject_feedbacks')
      .doc(rec.subjectId)
      .get()
      .then((v) => Feedback.fromMap(v.data()!));
});

final feedbackManagerProvider = AsyncNotifierProvider.autoDispose
    .family<FeedbackManager, bool?, ({String topicId, String subjectId})>(
  FeedbackManager.new,
);

class FeedbackManager extends AutoDisposeFamilyAsyncNotifier<bool?,
    ({String topicId, String subjectId})> {
  @override
  Future<bool?> build(({String topicId, String subjectId}) param) async {
    // The logic we previously had in our FutureProvider is now in the build method.
    final user = ref.watch(userDocProvider);

    if (!user.hasValue) {
      return Future.value(null);
    }

    return user.value!
        .collection("topic_feedbacks")
        .doc(param.topicId)
        .get()
        .then((value) => value.exists && value.get("status") == "submitted");
  }

  Future<void> saveAnswer({
    required Map<String, ({dynamic answer, String extra})> answers,
    bool completed = false,
  }) async {
    final userDoc = ref.read(userDocProvider);

    final answerDoc =
        userDoc.value!.collection("topic_feedbacks").doc(arg.topicId);

    final answerOpt = SetOptions(
      mergeFields: ["status", "answers", "updated_at"],
    );

    final data = {
      "subjectId": arg.subjectId,
      "topicId": arg.topicId,
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
      trx
          .set(
            answerDoc,
            data,
            answerOpt,
          )
          .set(
            userDoc.value!.collection("unlocked_topics").doc(arg.topicId),
            {
              "subjectId": arg.subjectId,
              "topicId": arg.topicId,
              "completedFeedback": true,
            },
            SetOptions(merge: true),
          );
    });
  }
}
