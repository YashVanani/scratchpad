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
  final int points;
  final List<QuizQuestion> questions;

  const Quiz({
    required this.id,
    required this.headline,
    required this.duration,
    required this.goals,
    required this.points,
    required this.questions,
  });

  factory Quiz.fromMap(Map<String, dynamic> data) {
    return Quiz(
      id: data["id"],
      headline: data["headline"],
      duration: data["dur"] ?? 0,
      goals: data["goals"],
      points: data["points"],
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

final quizManagerProvider =
    AsyncNotifierProvider.autoDispose<QuizStateUpdatedManager, void>(
  QuizStateUpdatedManager.new,
);

class QuizStateUpdatedManager extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // The logic we previously had in our FutureProvider is now in the build method.
  }

  Future<void> saveAnswer({
    required Quiz quiz,
    required String difficultyLevel,
    required Map<String, ({String answer, String extra})> answers,
    bool completed = false,
  }) async {
    final userDoc = ref.read(userDocProvider);

    final answerDoc = userDoc.value!.collection("quiz_answers").doc(quiz.id);

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
      trx.set(answerDoc, data, answerOpt).update(userDoc.value!, {
        "balance.total": FieldValue.increment(50),
        "balance.current": FieldValue.increment(50),
      }).set(userDoc.value!.collection("balance").doc(), {
        "type": "credit",
        "amount": 50,
        "module": "quiz",
        "quizId": quiz.id
      });
    });
  }
}
