import 'package:clarified_mobile/features/home/model/entry.dart';
import 'package:clarified_mobile/features/shared/widgets/page_buttom_slug.dart';
import 'package:clarified_mobile/features/shared/widgets/teacher_tag.dart';
import 'package:clarified_mobile/features/subjects/model/recent_topics.dart';
import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompletedTopicList extends ConsumerWidget {
  const CompletedTopicList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicProvider = ref.watch(recentTopicListProvider);
    final studentTopic = ref.watch(studentTopicFeedbackIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.recent_topics),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: topicProvider.maybeWhen(
            error: (_er, _st) => const SizedBox(),
            data: (topicList) {
              
              List<({DateTime completedAt, String subjectId, String subjectName, String teacherId, String topicId, String topicName})> newList = [];
              for(var i in topicList??[]){
                if(!(studentTopic.asData?.value.contains(i.topicId)??false)){
                  print("+++++HERE ID ");
                  newList.add(i);
                }
              }
              if (newList.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.no_topics_completed_yet),
                );
              }
          
              return ListView.separated(
                itemCount: newList.length,
                itemBuilder: (ctx, idx) {
                  final topic = newList[idx];

                  return Visibility(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFEAECF0),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0C101828),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  topic.subjectName,
                                  style: const TextStyle(
                                    color: Color(0xFF1D2939),
                                    fontSize: 16,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/crown.svg",
                                      width: 18,
                                      height: 18,
                                      theme: const SvgTheme(
                                        currentColor: Color(0xFFFAC515),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '+50 XP',
                                      style: TextStyle(
                                        color: Color(0xFFEAA907),
                                        fontSize: 12,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            topic.topicName,
                            style: const TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 14,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TeacherBug(
                                    teacherId: topic.teacherId,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF16B264),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => GoRouter.of(context).pushNamed(
                                      "topic-feedback",
                                      pathParameters: {
                                        "subjectId": topic.subjectId,
                                        "topicId": topic.topicId,
                                      },
                                      queryParameters: {
                                        "subjectName": topic.subjectName,
                                        "topicName": topic.topicName,
                                      }),
                                  child: Text(
                                    AppLocalizations.of(context)!.quick_feedback,
                                  /*const SizedBox(width: 4),
                                  Text(
                                    '+50 ${AppLocalizations.of(context)!.xp}',*/

                                    style: TextStyle(
                                      color: Color(0xFFFCFCFD),
                                      fontSize: 12,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, idx) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              );
            },
            orElse: () => Center(
              child: Text(AppLocalizations.of(context)!.no_topics_completed_yet),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const PageButtomSlug(),
    );
  }
}
