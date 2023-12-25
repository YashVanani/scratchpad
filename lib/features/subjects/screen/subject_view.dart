import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clarified_mobile/features/subjects/widget/subject_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubjectView extends ConsumerWidget {
  const SubjectView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.subjects),
      ),
      body: const SubjectListView(
        limit: -1,
      ),
    );
  }
}
