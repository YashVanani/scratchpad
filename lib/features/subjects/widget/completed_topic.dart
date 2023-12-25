import 'package:clarified_mobile/features/home/model/entry.dart';
import 'package:clarified_mobile/features/shared/widgets/teacher_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:clarified_mobile/features/subjects/model/recent_topics.dart';

class CompletedTopicCard extends ConsumerWidget {
  const CompletedTopicCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicListProvider = ref.watch(recentTopicListProvider);
    final studentTopic = ref.watch(studentTopicFeedbackIdProvider);
    return SizedBox(
      height: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Recently Completed Topics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              topicListProvider.maybeWhen(
                data: (topicList) {
                  if (topicList.isEmpty) return const SizedBox();

                  return TextButton(
                    onPressed: () =>
                        GoRouter.of(context).pushNamed("recent-topics"),
                    child: const Text("View all"),
                  );
                },
                orElse: () => const SizedBox(),
              ),
            ],
          ),
          Expanded(
            child: topicListProvider.when(
              data: (topicList) {
                List<({DateTime completedAt, String subjectId, String subjectName, String teacherId, String topicId, String topicName})> newList = [];
              for(var i in topicList??[]){
                if(!(studentTopic.asData?.value.contains(i.topicId)??false)){
                
                  newList.add(i);
                }
              }
             
                if (newList.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 22,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/svg/no_topics.svg"),
                        const Text(
                          "There are no new topics available",
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: newList.take(5).length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final topic = newList[index];

                    return Container(
                      width: 250,
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                        bottom: 16,
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
                            color: Color(0xFFEAECF0),
                            blurRadius: 0,
                            offset: Offset(0, 3),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            topic.subjectName,
                            style: const TextStyle(
                              color: Color(0xFF344054),
                              fontSize: 16,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            topic.topicName,
                            style: const TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 12,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                child: ClipRect(
                                  child: TeacherBug(
                                    teacherId: topic.teacherId,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
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
                          Row(
                            children: [
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
                                child: const Text(
                                  'Quick Feedback',
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
                        ],
                      ),
                    );
                  },
                );
              },
              error: (er, st) =>
                  const SizedBox(child: Text('There was an error')),
              loading: () => const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
