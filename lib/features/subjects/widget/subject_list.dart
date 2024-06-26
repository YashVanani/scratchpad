import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clarified_mobile/features/subjects/widget/subect_item.dart';
import 'package:clarified_mobile/model/clazz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
class SubjectListView extends ConsumerWidget {
  final int limit;

  const SubjectListView({
    super.key,
    required this.limit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectList = ref.watch(subjectListProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      // color: Colors.amber,
      child: subjectList.when(
        data: (subjects) {
          if (subjects.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.no_available_subjects),
            );
          }
          return StaggeredGrid.count(
            crossAxisCount: 3,
  mainAxisSpacing: 15,
  crossAxisSpacing: 15,
  children:subjects.map((e)=>SubjectItem(
                subject: e,
              )).toList(),
            // primary: false,
            // itemCount:
            //     limit > 0 && limit < subjects.length ? limit : subjects.length,
            // shrinkWrap: true,
            // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 3,
            //   mainAxisSpacing: 15,
            // ),
            // itemBuilder: (ctx, idx) {
            //   return SubjectItem(
            //     subject: subjects[idx],
            //   );
            // },
          );
        },
        error: (e, st) {
          print([e, st]);
          return Text(AppLocalizations.of(context)!.error_loading);
        },
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
