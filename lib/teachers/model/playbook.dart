import 'package:clarified_mobile/consts/localisedModel.dart';
import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:clarified_mobile/teachers/model/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final playbookColProvider = FutureProvider((ref) {
  final baseDoc = ref.read(schoolDocProvider);
  final userStream = ref.watch(userProvider);

  print(userStream.value?.uid);
  print("HERE");

  return baseDoc.collection("playbooks");
});

final teacherPlaybookProvider = StreamProvider<List<Playbook>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) {
                  print(doc.id);
                  if (doc.data()['type'] == 'parent') {}
                  return Playbook.fromJson(doc.data());
                })
                .where((element) => element.type == 'teacher')
                .toList(),
          ) ??
      const Stream.empty();
});

final teacherPlaybookSearchProvider = StreamProvider<List<Playbook>>((
  ref,
) {
  final playbookDocs = ref.watch(playbookColProvider);
  final searchQuery = ref.watch(teacherSearchPlaybookState.notifier).state;
  print(searchQuery);
  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()))
                .where((playbook) => (playbook.title?.en ?? '')
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList(),
          ) ??
      const Stream.empty();
});

final teacherPlaybookCategoryProvider = StreamProvider<Categories>((ref) {
  try {
    final playbookDocs = ref.watch(playbookColProvider);
    final baseDoc = ref.watch(schoolDocProvider);

    return baseDoc.collection("config").doc("playbook").get().then((value) {
      print(value.data());
      return Categories.fromJson(
          value.data()?['categories'] as Map<String, dynamic>);
    }).asStream();
  } catch (e) {
    return const Stream.empty();
  }
});

final teacherPlaybookDomainProvider =
    StreamProvider<List<LocalizedValue<String>>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()).domain ?? [])
                .expand((list) => list)
                .toList()
                .toSet()
                .toList(),
          ) ??
      const Stream.empty();
});

final teacherPlaybookDevelopStageProvider =
    StreamProvider<List<LocalizedValue<String>>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()).stages ?? [])
                .expand((list) => list)
                .toList()
                .toSet()
                .toList(),
          ) ??
      const Stream.empty();
});

final teacherDashboardPlaybookListProvider =
    StreamProvider<List<Playbook>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);
  final playbookIds = ref.watch(teacherPlaybookIdsState.notifier).state;

  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()))
                .where((playbook) => (playbookIds).contains(playbook.id))
                .toList(),
          ) ??
      const Stream.empty();
});

final teacherFavoriteActivityProvider = StreamProvider<List<Playbook>>((ref) {
  ref.refresh(teacherProfileProvider);
  final playbookDocs = ref.watch(playbookColProvider);
  final playbookIds = ref.watch(teacherFavoriteActivityState.notifier).state;
  print("++++PLAYBOOK SAVED ${playbookIds}");
  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()))
                .where((playbook) => (playbookIds).contains(playbook.id))
                .toList(),
          ) ??
      const Stream.empty();
});

final teacherAppliedActivityProvider = StreamProvider<List<Playbook>>((ref) {
  final playbookDocs = ref.watch(playbookColProvider);
  final playbookIds = ref.watch(teacherAppliedActivityState.notifier).state;
  print("++++PLAYBOOK SAVED ${playbookIds}");
  return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
            (v) => v.docs
                .map((doc) => Playbook.fromJson(doc.data()))
                .where((playbook) => (playbookIds).contains(playbook.id))
                .toList(),
          ) ??
      const Stream.empty();
});

Future<bool> applyStrategy(
    {required String classId,
    required DateTime time,
    required String message,
    required String playbookId,
    required String playbookTitle,
    required WidgetRef ref}) async {
  final teacherDoc = ref.watch(teacherDocProvider);
  final baseDoc = ref.read(schoolDocProvider);
  try {
    
   Classroom classroom = await baseDoc
      .collection("classes")
      .doc(classId)
      .get()
        .then((value) => Classroom.fromMap(value.data()!) );
  //     .map((event) {
  //   return event.exists ? Classroom.fromMap(event.data()!) : Classroom.empty();
  // });
    await teacherDoc.asData?.value.update({
      'appliedActivities':FieldValue.arrayUnion([playbookId])
    });
    await teacherDoc.asData?.value.collection('calendars').doc().set({
      'classId':classId,
      'className':classroom.name,
      'date':Timestamp.fromDate(time),
      'dateKey':'${time.year}-${time.month}-${time.day}',
      'isCompleted':false,
      'monthKey':Timestamp.fromDate(time),
      'notes':message,
      'playbookId':playbookId,
      'title':playbookTitle,
      'type':'task'
    });
    return true;
  } catch (e) {
    return false;
  }
}

final teacherFavoriteActivityState = StateProvider<List<String>>((ref) => []);
final teacherAppliedActivityState = StateProvider<List<String>>((ref) => []);
final teacherPlaybookIdsState = StateProvider<List<String>>((ref) => []);
final teacherSearchPlaybookState = StateProvider((_) => '');
final teacherFilterProvider = StateProvider((_) => {});
final teacherSelectedCategoryProvider = StateProvider((String) => 'All');
