import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clarified_mobile/model/user.dart' as u;
// To parse this JSON data, do
//
//     final peerSurvey = peerSurveyFromJson(jsonString);

import 'dart:convert';

PeerSurvey peerSurveyFromJson(String str) =>
    PeerSurvey.fromJson(json.decode(str));

String peerSurveyToJson(PeerSurvey data) => json.encode(data.toJson());

class PeerSurvey {
  List<Question>? questions;
  List<String>? peerDone;

  PeerSurvey({
    this.questions,
    this.peerDone,
  });

  factory PeerSurvey.fromJson(Map<String, dynamic> json) => PeerSurvey(
        questions: json["questions"] == null
            ? []
            : List<Question>.from(
                json["questions"]!.map((x) => Question.fromJson(x))),
        peerDone: json["peer_done"] == null
            ? []
            : List<String>.from(json["peer_done"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "questions": questions == null
            ? []
            : List<dynamic>.from(questions!.map((x) => x.toJson())),
        "peer_done":
            peerDone == null ? [] : List<dynamic>.from(peerDone!.map((x) => x)),
      };
}

class Question {
  String? id;
  String? questionText;

  Question({
    this.id,
    this.questionText,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        questionText: json["questionText"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "questionText": questionText,
      };
}

final peerSurveyProvider = StreamProvider((ref) {
  final schoolDoc = ref.watch(schoolDocProvider);

  return schoolDoc
      .collection("surveys")
      .doc(ref.read(currentSurveyId.notifier).state)
      .collection('peer_survey')
      .doc(ref.read(currentPeerSurveyId.notifier).state)
      .get()
      .then((value) {
    print(ref.read(currentSurveyId.notifier).state);
    print(ref.read(currentPeerSurveyId.notifier).state);
    print(value.data());
    print("+++GETSURRVEY DETAIL");
    return PeerSurvey.fromJson(value.data() as Map<String, dynamic>);
  }).asStream();
});
//   .where("id", whereIn: userProfile.value?.surveyInbox)
//   .where("type", isEqualTo: "student")
//   .where("expiresAt", isGreaterThanOrEqualTo: Timestamp.now())
//   .orderBy("expiresAt")
//   .orderBy("startAt")
//   .limit(1)
//   .snapshots()
//   .map(
// (rec) {
//   return rec.size != 1 ? null : PeerSurvey.fromJson(rec.docs.first.data());
// },
//   );
// });
Future<List<u.UserInfo>> classRoomUserListProvider(WidgetRef ref) async {
  try {
    final baseDoc = ref.read(schoolDocProvider);
    final profile = ref.watch(profileProvider);
    List<u.UserInfo> users = [];
    QuerySnapshot<Map<String, dynamic>> data = await baseDoc
        .collection('students')
        .where('currentClassId',
            isEqualTo: profile.asData?.value.currentClassId)
        .get();
    for (QueryDocumentSnapshot i in data.docs ?? []) {
      print("+++++DONE ${ref.read(donePeerIdList.notifier).state}");
      if (!ref.read(donePeerIdList.notifier).state.contains(i.id)) {
        users.add(u.UserInfo.fromMap(i.data() as Map<String, dynamic>));
      }
    }
    return users;
  } catch (e) {
    print("ERROR ${e}");
    return [];
  }
}

Future<bool> checkPeerSurveyExist(String surveyId, WidgetRef ref) async {
  final baseDoc = ref.read(schoolDocProvider);
  ref.read(currentSurveyId.notifier).state = surveyId;
  QuerySnapshot res = await baseDoc
      .collection('surveys')
      .doc(surveyId)
      .collection('peer_survey')
      .get();
  print("++++RES${res.docs}");
  if (res.docs.isNotEmpty) {
    List peers = [];
    try {
      QueryDocumentSnapshot data = await res.docs[0];
      var d = data.data();
      peers = ((d as Map<String, dynamic>)['recievedIds'] ?? []);
    } catch (e) {}
      Map<String, int> idCount = Map();
  for (String id in peers) {
    idCount[id] = (idCount[id] ?? 0) + 1;
  }

  // Filter IDs that are present less than 3 times
  List<String> result = idCount.entries
      .where((entry) => entry.value >= 3)
      .map((entry) => entry.key)
      .toList();
    ref.read(donePeerIdList.notifier).state = result;
    ref.read(currentPeerSurveyId.notifier).state = res.docs[0].id;
    return true;
  }
  return false;
}

final peerManagerProvider = AsyncNotifierProvider.autoDispose
    .family<PeerManager, bool?, ({String surveyId, String peerId})>(
  PeerManager.new,
);

class PeerManager extends AutoDisposeFamilyAsyncNotifier<bool?,
    ({String surveyId, String peerId})> {
  @override
  Future<bool?> build(({String surveyId, String peerId}) param) async {
    // The logic we previously had in our FutureProvider is now in the build method.
    final user = ref.watch(userDocProvider);

    if (!user.hasValue) {
      return Future.value(null);
    }

    return user.value!
        .collection("peer_feedbacks")
        .doc(param.peerId)
        .get()
        .then((value) => value.exists && value.get("status") == "submitted");
  }

  Future<void> saveAnswer({
    required Map<String, Map<String, double>> answers,
    bool completed = false,
  }) async {
    final baseDoc = ref.read(schoolDocProvider);
    final userProfile = ref.watch(profileProvider);
    
    final answerDoc =
        baseDoc
      .collection("surveys")
      .doc(ref.read(currentSurveyId.notifier).state)
      .collection('peer_survey')
      .doc(ref.read(currentPeerSurveyId.notifier).state).collection('responses').doc(userProfile.asData?.value.id);

    final answerOpt = SetOptions(
      mergeFields: [
        "status",
        "answers",
        "updated_at",
      ],
    );

    final data = {
      "peerId": arg.peerId,
      "surveyId": arg.surveyId,
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
      "status": completed ? "submitted" : "pending",
      "answers": answers
    };

    if (!completed) {
      return answerDoc.set(data, answerOpt);
    }
    return FirebaseFirestore.instance.runTransaction((trx) async {
      try {
        await baseDoc
            .collection('surveys')
            .doc(arg.surveyId)
            .collection('peer_survey')
            .doc(arg.peerId)
            .update({
          'recievedIds': FieldValue.arrayUnion(
              ref.read(selectedPeerIdList.notifier).state),
          'givenIds': FieldValue.arrayUnion([userProfile.asData?.value.id]),
        });
      } catch (e) {
        print("++++ERROR++${e}");
      }
      trx.set(
        answerDoc,
        data,
        answerOpt,
      );
      ref.read(selectedPeerList.notifier).state = [];
      ref.read(selectedPeerIdList.notifier).state = [];
      ref.read(currentSurveyId.notifier).state = '';
      ref.read(currentPeerSurveyId.notifier).state = '';
      ref.read(donePeerIdList.notifier).state = [];
    });
  }
}

final donePeerIdList = StateProvider<List>((_) => []);
final selectedPeerList = StateProvider<List<u.UserInfo?>>((_) => []);
final selectedPeerIdList = StateProvider<List<String>>((_) => []);
final currentSurveyId = StateProvider(<String>(ref) => '');
final currentPeerSurveyId = StateProvider(<String>(ref) => '');
