import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef RecentTopicRecord = ({
  String subjectId,
  String teacherId,
  String topicId,
  String subjectName,
  String topicName,
  DateTime completedAt,
});

final recentTopicListProvider = FutureProvider<List<RecentTopicRecord>>((ref) {
  final classroom = ref.watch(classroomProvider);
  final subjectList = ref.watch(subjectListProvider);

  if (classroom.hasValue && subjectList.hasValue) {
    final completedTopics = classroom.value!.subjects.expand((s) {
      final subject = subjectList.value!.firstWhere(
        (si) => si.id == s.subjectId,
        orElse: () => Subject.fromMap(
          const {
            "name": "Unknown Subject",
            "id": "--",
            "topics": [],
          },
        ),
      );

      return s.topics
          .where(
            (t) => t.isCompleted == true,
          )
          .map<RecentTopicRecord>(
            (t) => (
              subjectId: s.subjectId,
              teacherId: s.teacherId,
              topicId: t.id,
              subjectName: subject.name,
              topicName: t.topic,
              completedAt: t.completedAt ?? DateTime.now()
            ),
          );
    }).toList();

    return completedTopics
      ..sort((r1, r2) => r2.completedAt.compareTo(r1.completedAt));
  }

  return List<RecentTopicRecord>.from([]);
});

final recentTopicItemProvider = FutureProvider.autoDispose
    .family((ref, ({String topicId, String subjectId}) param) {
  final topicList = ref.watch(recentTopicListProvider);

  return topicList.value?.firstWhere(
    (t) => t.subjectId == param.subjectId && t.topicId == param.topicId,
  );
});

typedef UnlockRecord = ({
  bool completedFeedback,
  String topicId,
  List<String> unlockedAssets
});

final unlockedTopicListProvider =
    StreamProvider.family((ref, String subjectId) {
  final userDoc = ref.watch(userDocProvider);

  if (userDoc.hasValue) {
    return userDoc.value!
        .collection("unlocked_topics")
        .where("subjectId", isEqualTo: subjectId)
        .snapshots()
        .map((ev) => ev.docs.where((e) => e.exists).map<UnlockRecord>((e) {
              final content = e.data();
              return (
                topicId: "${content["topicId"]}",
                unlockedAssets:
                    List<String>.from(content['unlockedAssets'] ?? []),
                // ["case-study", "material", "quiz"],
                completedFeedback: content["feedback"] == true,
              );
            }).toList());
  }

  return Stream<List<UnlockRecord>>.value([]);
});

final topicUnlockManagerProvider =
    AsyncNotifierProvider.autoDispose<TopicStateUpdatedManager, void>(
  TopicStateUpdatedManager.new,
);

class TopicStateUpdatedManager extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // The logic we previously had in our FutureProvider is now in the build method.
  }
  Future<void> purchaseTopicArtifact(
      {required Topic topic,
      required String subjectId,
      required String artifact,
      required BuildContext context,
      required WidgetRef ref
      }) async {
    final userDoc = ref.read(userDocProvider);
    final schoolDoc = ref.read(schoolDocProvider);

    final costMap = {
      'case-study': topic.cost.caseStudy,
      'quiz': topic.cost.quiz,
      'materials': topic.cost.materials,
    };

    if (!costMap.containsKey(artifact)) {
      return;
    }

    int price = costMap[artifact]!;

    var artifactDocs = await schoolDoc
        .collection('subjects')
        .doc(subjectId)
        .collection('assets')
        .where('type', isEqualTo: artifact)
        .get();
    if (artifactDocs.docs.isEmpty) {
      var snackBar = SnackBar(content: Text("no material available"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    return FirebaseFirestore.instance.runTransaction((trx) async {
      trx
          .update(userDoc.value!, {
            "balance.current": FieldValue.increment(-1 * price),
            "balance.spent": FieldValue.increment(price!),
          })
          .set(
              userDoc.value!.collection("unlocked_topics").doc(topic.id),
              {
                "subjectId": subjectId,
                "topicId": topic.id,
              },
              SetOptions(merge: true))
          .update(
            userDoc.value!.collection("unlocked_topics").doc(topic.id),
            {
              "unlockedAssets": FieldValue.arrayUnion([artifact]),
            },
          )
          .set(userDoc.value!.collection("balance").doc(), {
            "type": "debit",
            "module": "topic-item",
            "amount": price,
            "topicId": topic.id,
            "subjectId": subjectId,
          })
          .set(userDoc.value!.collection("notifications").doc(), {
            "type": "purchase",
            "module": "topic-item",
            "message": "$artifact for ${topic.name} unlocked"
          });
      createStudentNotification('Unlocked Resource', "$artifact for ${topic.name} unlocked", 'Resource', ref);    
    });
  }
}
