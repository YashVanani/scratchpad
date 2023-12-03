import 'package:clarified_mobile/features/shared/widgets/page_buttom_slug.dart';
import 'package:clarified_mobile/features/shared/widgets/teacher_tag.dart';
import 'package:clarified_mobile/features/subjects/model/recent_topics.dart';
import 'package:clarified_mobile/model/clazz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CompletedTopicList extends ConsumerWidget {
  const CompletedTopicList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicProvider = ref.watch(recentTopicListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recent Topics"),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: topicProvider.maybeWhen(
            error: (_er, _st) => const SizedBox(),
            data: (topicList) {
              if (topicList.isEmpty) {
                return const Center(
                  child: Text("No Topics Completed Yet"),
                );
              }
              return ListView.separated(
                itemCount: topicList.length,
                itemBuilder: (ctx, idx) {
                  final topic = topicList[idx];

                  return Container(
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
                        ),
                      ],
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
            orElse: () => const Center(
              child: Text("No Topics Completed Yet"),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const PageButtomSlug(),
    );
  }
}
