import 'package:clarified_mobile/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attemptedQuizCountProvider = FutureProvider.autoDispose((ref) {
  final userDoc = ref.watch(userDocProvider);

  if (!userDoc.hasValue) return 0;
  return userDoc.value!
      .collection("quiz_answers")
      .where("status", isEqualTo: "submitted")
      .count()
      .get()
      .then((value) => value.count);
});
