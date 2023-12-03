import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:clarified_mobile/features/home/widgets/survey_card.dart';
import 'package:clarified_mobile/features/shared/widgets/app_buttombar.dart';
import 'package:clarified_mobile/features/subjects/widget/completed_topic.dart';
import 'package:clarified_mobile/features/subjects/widget/subject_list.dart';
import 'package:clarified_mobile/model/user.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.account_circle_outlined),
        titleSpacing: 0,
        leadingWidth: 42.0,
        toolbarHeight: 70,
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            // onPressed: () => print("language"),
            onPressed: () {
              GoRouter.of(context).pushNamed("parents-home");
            },
            icon: const Icon(
              Icons.translate_outlined,
            ),
          ),
          IconButton(
            onPressed: () => print('outline'),
            icon: const Icon(
              Icons.help_outline_outlined,
            ),
          ),
          IconButton(
            onPressed: () =>
                GoRouter.of(context).pushNamed("profile-notification"),
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          )
        ],
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "Hello\n", style: TextStyle(fontSize: 12)),
              profile.when(
                data: (u) => TextSpan(text: u.name),
                error: (e, st) {
                  return const TextSpan(text: "Error Loading User");
                },
                loading: () => const TextSpan(text: "---"),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8,
            ),
            decoration: ShapeDecoration(
              color: Colors.white,
              shadows: const [
                BoxShadow(
                  color: Colors.blueGrey,
                  offset: Offset(0, 1),
                ),
              ],
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Total XP available"),
                Center(
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFEFBE8),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFFDE272),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => print("ICONS"),
                      icon: SvgPicture.asset(
                        "assets/svg/crown.svg",
                        theme: const SvgTheme(
                          currentColor: Color(0xFFFAC515),
                        ),
                      ),
                      label: profile.when(
                        data: (u) => Text("${u.xpBalance}"),
                        error: (e, st) {
                          return const Text("0");
                        },
                        loading: () => const Text("-"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16,
            ),
            child: SurveyCard(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10,
            ),
            child: const CompletedTopicCard(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 32.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subjects"),
                    TextButton(
                      onPressed: () => GoRouter.of(context).push("/subjects"),
                      child: const Text("View All"),
                    )
                  ],
                ),
                const SubjectListView(
                  limit: 6,
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: const AppNavBar(
        selected: 'home',
      ),
    );
  }
}
