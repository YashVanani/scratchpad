import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clarified_mobile/features/subjects/widget/subject_list.dart';

class SubjectView extends ConsumerWidget {
  const SubjectView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: const Text("Subjects"),
      ),
      body: const SubjectListView(
        limit: -1,
      ),
    );
  }
}
