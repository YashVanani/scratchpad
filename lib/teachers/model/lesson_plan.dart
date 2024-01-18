import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart';

final classroomLessonProvider = StreamProvider((ref) {
  final baseDoc = ref.watch(schoolDocProvider);


  return baseDoc
      .collection("classes")
      .doc(ref.read(selectedClassIdLessonState.notifier).state)
      .snapshots()
      .map((event) {
    return event.exists ? Classroom.fromMap(event.data()!) : Classroom.empty();
  });
});

final classroomSubjectLessonProvider = Provider<List<ClassSubject>>((ref) {
  final croom = ref.refresh(classroomLessonProvider);
  return croom.hasValue ? croom.value!.subjects : [];
});

final subjectListLessonProvider = StreamProvider((ref) {
  final baseDoc = ref.watch(schoolDocProvider);
  final cr = ref.watch(classroomLessonProvider);

  print("SUBJKECT");
  print(cr.value?.subjects.map((e) => e.subjectId));
  return
 baseDoc
      .collection("subjects")
      .where(
        "id",
        whereIn: cr.value?.subjects.map((e) => e.subjectId),
      )
      .snapshots()
      .map(
        (ev) => ev.docs
            .where((d) => d.exists)
            .map((d) => Subject.fromMap(d.data()))
            .toList(),
      );
      
      }
   
);

final selectedClassIdLessonState = StateProvider((_) => '');
final selectedsubjectIdLessonState = StateProvider((_) => '');
