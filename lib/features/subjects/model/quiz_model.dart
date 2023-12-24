import 'package:clarified_mobile/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clarified_mobile/model/school.dart';

class QuizQuestion {
  final String id;
  final String questionText;
  final List<String> answers;
  final String answer;
  final String level;
  final String answerComment;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.explanation,
    required this.answerComment,
    required this.answer,
    required this.level,
    required this.answers,
    required this.questionText,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> data) {
    return QuizQuestion(
      id: data["id"],
      level: data["level"],
      explanation: data["explanation"] ?? "",
      answerComment: data["answerComment"] ?? "",
      answer: data["answer"],
      answers: List.from(
        data["answers"] is Iterable ? data["answers"] : [],
      ),
      questionText: data["questionText"],
    );
  }
}

class Quiz {
  final String id;
  final String headline;
  final int duration;
  final String goals;
  final String topicId;
  final String subjectId;
  final int points;
  final List<QuizQuestion> questions;

  const Quiz(
      {required this.id,
      required this.headline,
      required this.duration,
      required this.goals,
      required this.points,
      required this.questions,
      required this.subjectId,
      required this.topicId});

  factory Quiz.fromMap(Map<String, dynamic> data) {
    return Quiz(
      id: data["id"],
      headline: data["headline"],
      duration: data["dur"] ?? 0,
      goals: data["goals"],
      points: data["points"],
      topicId: data['topicId'] ?? "",
      subjectId: data['subjectid'] ?? '',
      questions: List.from(
        data["questions"] is Iterable ? data["questions"] : [],
      ).map((q) => QuizQuestion.fromMap(q)).toList(),
    );
  }
}

final quizProvider = FutureProvider.family((ref,
    ({
      String subjectId,
      String topicId,
      String type,
    }) p) {
  final schoolDoc = ref.watch(schoolDocProvider);

  return schoolDoc
      .collection("subjects")
      .doc(p.subjectId)
      .collection("assets")
      .where("type", isEqualTo: p.type)
      .where("topicId", isEqualTo: p.topicId)
      .where("subjectId", isEqualTo: p.subjectId)
      .limit(1)
      .get()
      .then((v) => v.size == 1 ? Quiz.fromMap(v.docs.first.data()) : null);
});

final caseStudyProvider = FutureProvider.family((ref,
    ({
      String subjectId,
      String topicId,
      String type,
    }) p) {
  final schoolDoc = ref.watch(schoolDocProvider);
  return schoolDoc
      .collection("subjects")
      .doc(p.subjectId)
      .collection("assets")
      .where("type", isEqualTo: p.type)
      .where("topicId", isEqualTo: p.topicId)
      .where("subjectId", isEqualTo: p.subjectId)
      .limit(1)
      .get()
      .then((v) => v.size == 1 ? v.docs.first.data() : null);
});

final topicMaterialProvider = FutureProvider.family((ref,
    ({
      String subjectId,
      String topicId,
      String type,
    }) p) {
  final schoolDoc = ref.watch(schoolDocProvider);
  return schoolDoc
      .collection("subjects")
      .doc(p.subjectId)
      .collection("assets")
      .where("type", isEqualTo: p.type)
      .where("topicId", isEqualTo: p.topicId)
      .where("subjectId", isEqualTo: p.subjectId)
      .limit(1)
      .get()
      .then((v) => v.docs);
});

final quizAttemptProvider = StreamProvider((ref) {
  final user = ref.watch(userDocProvider);

  if (!user.hasValue) {
    return Stream.value([{}]);
  }

  return user.value!
      .collection("quiz_answers")
      .snapshots()
      .map((event) => event.docs.map((e) {
            List level;
            String topicId;
            try {
              topicId = e.data()['topic_id'];
              level = e.data()['level'];
            } catch (e) {
              level = [];

              topicId = '';
            }
            return {'id': topicId ?? '', 'level': level ?? ''};
          }).toList());
});

// final quizManagerProvider =
//     AsyncNotifierProvider.autoDispose<QuizStateUpdatedManager, void>(
//   QuizStateUpdatedManager.new,
// );

// class QuizStateUpdatedManager extends AutoDisposeAsyncNotifier<void> {
//   @override
//   Future<void> build() async {
//     // The logic we previously had in our FutureProvider is now in the build method.
//   }

//   Future<void> saveAnswer({
//     required Quiz quiz,
//     required String difficultyLevel,
//     required Map<String, ({String answer, String extra})> answers,
//     bool completed = false,
//   }) async {
//     final userDoc = ref.read(userDocProvider);

//     final answerDoc = userDoc.value!.collection("quiz_answers").doc(quiz.id);

//     final answerOpt = SetOptions(
//       mergeFields: ["status", "answers", "updated_at"],
//     );

//     final data = {
//       "created_at": Timestamp.now(),
//       "updated_at": Timestamp.now(),
//       "status": completed ? "submitted" : "pending",
//       "answers": Map.fromEntries(
//         answers.entries.map(
//           (e) => MapEntry(e.key, {
//             "answer": e.value.answer,
//             "data": e.value.extra,
//           }),
//         ),
//       ),
//     };

//     if (!completed) {
//       return answerDoc.set(data, answerOpt);
//     }

//     return FirebaseFirestore.instance.runTransaction((trx) async {
//       trx.set(answerDoc, data, answerOpt).update(userDoc.value!, {
//         "balance.total": FieldValue.increment(50),
//         "balance.current": FieldValue.increment(50),
//       }).set(userDoc.value!.collection("balance").doc(), {
//         "type": "credit",
//         "amount": 50,
//         "module": "quiz",
//         "quizId": quiz.id
//       });
//     });
//   }
// }

class QuizManager extends AutoDisposeFamilyAsyncNotifier<bool?,
    ({String topicId, String subjectId})> {
  @override
  Future<bool?> build(({String topicId, String subjectId}) param) async {
    // The logic we previously had in our FutureProvider is now in the build method.
    final user = ref.watch(userDocProvider);

    if (!user.hasValue) {
      return Future.value(null);
    }

    return user.value!
        .collection("topic_quizs")
        .doc(param.topicId)
        .get()
        .then((value) => value.exists && value.get("status") == "submitted");
  }

  Future<void> saveAnswer({
    required Quiz quiz,
    required String difficultyLevel,
    required Map<
            String,
            ({
              dynamic answer,
              String? extra,
              bool isCorrect,
            })>
        answers,
    bool completed = false,
    required DateTime startAt,
    required WidgetRef ref,
    required String level,
  }) async {
    try {
      final userDoc = ref.read(userDocProvider);
      final answerDoc = userDoc.value!.collection("quiz_answers").doc(quiz.id);

      final answerOpt = SetOptions(
        mergeFields: [
          "status",
          "answers",
          "updated_at",
          'created_at',
          'updated_at',
          'completed_in',
          'level',
          'topic_id'
        ],
      );
      DocumentSnapshot res = await answerDoc.get();
      List levelList = [level];
      List oldLevel = [];
      try {
        oldLevel = res.get('level') ?? [];
      } catch (e) {}
      levelList.addAll(oldLevel);
      levelList = levelList.toSet().toList();
      final data = {
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
        "status": completed ? "submitted" : "pending",
        "completed_in": completed
            ? '${DateTime.now().difference(startAt).inMinutes}:${DateTime.now().difference(startAt).inSeconds}'
            : null,
        "answers": Map.fromEntries(
          answers.entries.map(
            (e) => MapEntry(e.key, {
              "answer": e.value.answer,
              "data": e.value.extra ?? "",
              "isCorrect": e.value.isCorrect
            }),
          ),
        ),
        'level': levelList,
        'topic_id': quiz.topicId
      };
      if (!completed) {
        return answerDoc.set(data, answerOpt);
      }

      return FirebaseFirestore.instance.runTransaction((trx) async {
        try {
          await userDoc.value?.update({
            "balance.total": FieldValue.increment(quiz.points ?? 50),
            "balance.current": FieldValue.increment(quiz.points ?? 50),
          });
          trx
              .set(answerDoc, data, answerOpt)
              .set(userDoc.value!.collection("balance").doc(), {
            "type": "credit",
            "amount": quiz.points ?? 50,
            "module": "quiz",
            "quizId": quiz.id
          });
        } catch (e) {}
      });
    } catch (e) {}
  }
}

final QuizManagerProvider = AsyncNotifierProvider.autoDispose
    .family<QuizManager, bool?, ({String topicId, String subjectId})>(
  QuizManager.new,
);
