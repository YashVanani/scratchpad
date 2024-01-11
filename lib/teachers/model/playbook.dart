// import 'package:clarified_mobile/model/school.dart';
// import 'package:clarified_mobile/parents/models/playbook.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final userProvider = StreamProvider(
//   (ref) => FirebaseAuth.instance.authStateChanges(),
// );

// final playbookColProvider = FutureProvider((ref) {
//   final baseDoc = ref.read(schoolDocProvider);
//   final userStream = ref.watch(userProvider);

//   print(userStream.value?.uid);
//   print("HERE");

//   return baseDoc.collection("playbooks");
// });

// final teacherPlaybookProvider = StreamProvider<List<Playbook>>((ref) {
//   final playbookDocs = ref.watch(playbookColProvider);

//   return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
//             (v) => v.docs
//                 .map((doc){
//                   print(doc.id);
//                   if(doc.data()['type']=='parent'){}
//                   return Playbook.fromJson(doc.data());
//                 }).where((element) => element.type=='teacher')
//                 .toList(),
//           ) ??
//       const Stream.empty();
// });

// final teacherPlaybookSearchProvider = StreamProvider<List<Playbook>>((ref,) {
//   final playbookDocs = ref.watch(playbookColProvider);
//   final searchQuery = ref.watch(teacherSearchPlaybookState.notifier).state;
//   print(searchQuery);
//   return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
//     (v) => v.docs
//         .map((doc) => Playbook.fromJson(doc.data()))
//         .where((playbook) => (playbook.title??'').toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList(),
//   ) ?? const Stream.empty();
// });

// final teacherPlaybookCategoryProvider =StreamProvider<Categories>((ref) {
//   try{
//       final playbookDocs = ref.watch(playbookColProvider);
//   final baseDoc = ref.watch(schoolDocProvider);

//   return baseDoc
//       .collection("config")
//       .doc("playbook")
//       .get().then((value){
//         print(value.data());
//         return Categories.fromJson(value.data()?['categories'] as Map<String, dynamic>);
//       }).asStream();
      
//   }catch(e){

//     return  const Stream.empty();
//   }
 
// });

// final teacherPlaybookDomainProvider =StreamProvider<List<String>>((ref) {
//   final playbookDocs = ref.watch(playbookColProvider);

//   return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
//             (v) => v.docs
//                 .map((doc) => Playbook.fromJson(doc.data()).domain??[]).expand((list) => list).toList().toSet()
//                 .toList(),
//           ) ??
//       const Stream.empty();
// });

// final teacherPlaybookDevelopStageProvider =StreamProvider<List<String>>((ref) {
//   final playbookDocs = ref.watch(playbookColProvider);

//   return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
//             (v) => v.docs
//                 .map((doc) => Playbook.fromJson(doc.data()).stages??[]).expand((list) => list).toList().toSet()
//                 .toList(),
//           ) ??
//       const Stream.empty();
// });

// final teacherDashboardPlaybookListProvider = StreamProvider<List<Playbook>>((ref) {
//   final playbookDocs = ref.watch(playbookColProvider);
//   final playbookIds = ref.watch(teacherPlaybookIdsState.notifier).state;

//    return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
//     (v) => v.docs
//         .map((doc) => Playbook.fromJson(doc.data()))
//         .where((playbook) => (playbookIds).contains(playbook.id))
//         .toList(),
//   ) ?? const Stream.empty();
// });

// final teacherFavoriteActivityProvider = StreamProvider<List<Playbook>>((ref) {
//   final playbookDocs = ref.watch(playbookColProvider);
//   final playbookIds = ref.watch(teacherFavoriteActivityState.notifier).state;
//   print("++++PLAYBOOK SAVED ${playbookIds}");
//    return playbookDocs.value?.snapshots().where((ev) => ev.docs.isNotEmpty).map(
//     (v) => v.docs
//         .map((doc) => Playbook.fromJson(doc.data()))
//          .where((playbook) => (playbookIds).contains(playbook.id))
//         .toList(),
//   ) ?? const Stream.empty();
// });


// final teacherFavoriteActivityState = StateProvider<List<String>>((ref) => []);
// final teacherPlaybookIdsState = StateProvider<List<String>>((ref) => []);
// final teacherSearchPlaybookState = StateProvider((_) => '');
// final teacherFilterProvider = StateProvider((_) => {});
// final teacherSelectedCategoryProvider = StateProvider((String) => 'All');