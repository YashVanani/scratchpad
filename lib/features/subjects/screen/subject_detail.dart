import 'package:cached_network_image/cached_network_image.dart';
import 'package:clarified_mobile/features/shared/widgets/teacher_tag.dart';
import 'package:clarified_mobile/features/shared/widgets/unlock_pop_up.dart';
import 'package:clarified_mobile/features/subjects/model/recent_topics.dart';
import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const _defaultBannerHash =
    r'|BQ7%Ztn@KTC.oz;.sVxq|pNN=Ivr]xwkXrcrveZ.zExP2xbX%#;Ttr?t2_x%hPSM_RhMfjEoeXMD5ZhxUTKTexat7kSo}[eKPOqz?nipBTDs,V@-TxusDM|NFs*OER%o0,*vNVbpFb^NfaOk;TJyDw5n7XQV@X8THS0aK';

class SubjectDetail extends ConsumerWidget {
  final String subjectId;

  const SubjectDetail({
    super.key,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final rez = ref.watch(subjectItemProvider(subjectId));
    final unlockdedItems = ref.watch(unlockedTopicListProvider(subjectId));
    final lastCompletedIndex = rez.topics.lastIndexWhere((t) => t.isCompleted);
    final purchaseHandler = ref.read(topicUnlockManagerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(rez.subject?.name ?? AppLocalizations.of(context)!.not_loaded),
      ),
      body: Container(
        color: const Color(0xFFF9FAFB),
        child: ListView(
          shrinkWrap: true,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child:
                  Uri.tryParse((rez.subject?.bannerImage ?? "").trim()) != null
                      ? CachedNetworkImage(
                          imageUrl: rez.subject!.bannerImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return const BlurHash(
                              hash: _defaultBannerHash,
                            );
                          },
                          errorWidget: (context, url, error) {
                            return const BlurHash(
                              hash: _defaultBannerHash,
                            );
                          },
                        )
                      : const BlurHash(
                          hash: _defaultBannerHash,
                        ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    // flex: 8,
                    child: Text(AppLocalizations.of(context)!.teacher_name),
                  ),
                  Expanded(
                    // flex: 4,
                    child: TeacherBug(
                      teacherId: rez.teacherId,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(AppLocalizations.of(context)!.lesson_plan),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: rez.topics.length,
                itemBuilder: (BuildContext context, int index) {
                  final topic = rez.subject!.topics[index];
                  final idx = unlockdedItems.valueOrNull?.indexWhere(
                        (e) => e.topicId == topic.id,
                      ) ??
                      -1;

                  final lockRecord =
                      idx > -1 ? unlockdedItems.value![idx] : null;
                  print(idx > -1 ? unlockdedItems.value![idx] : null);
                  return _LessonPlan(
                    index: index + 1,
                    topic: rez.topics[index],
                    unlockedAssets: lockRecord?.unlockedAssets ?? [],
                    unlocked: lockRecord?.completedFeedback == true,
                    expanded: index <= (lastCompletedIndex + 1),
                    baseTopic: topic,
                    executeAsset: (artifact, cost) async {
                      final isOwned = (lockRecord?.completedFeedback == true ||
                          lockRecord?.unlockedAssets.contains(artifact) ==
                              true);

                      if (isOwned) {
                        switch (artifact) {
                          case "quiz":
                            print(artifact);
                            GoRouter.of(context).pushNamed(
                              "topic-quiz",
                              queryParameters: {
                                "subjectId": subjectId,
                                "topicId": topic.id,
                                "topicName": topic.name,
                                "subjectName": rez.subject?.name ?? "",
                                
                              },
                            );
                            return;
                          case "case-study":
                            GoRouter.of(context).pushNamed(
                              "case-study",
                              queryParameters: {
                                "subjectId": subjectId,
                                "topicId": topic.id,
                              },
                            );
                            return;

                          case "materials":
                            GoRouter.of(context).pushNamed(
                              "course-material",
                              queryParameters: {
                                "subjectId": subjectId,
                                "topicId": topic.id,
                                "topicName": topic.name,
                                "subjectName": rez.subject?.name ?? "",
                              },
                            );
                            return;
                        }

                        return Future.value();
                      }

                      if (cost > profile.value!.balance.current) {
                        Fluttertoast.showToast(msg: AppLocalizations.of(context)!.not_enough_balance);
                        return;
                      }

                      return showModalBottomSheet(
                        context: context,
                        builder: (ctx) => UnlockPopUp(
                          message:
                              '${AppLocalizations.of(context)!.are_you_sure_you_want_to_spend} $cost ${AppLocalizations.of(context)!.xp_to_unlock_this} $artifact?',
                          onConfirmed: () async {
                            if (cost > profile.value!.xpBalance) {
                              Fluttertoast.showToast(msg: AppLocalizations.of(context)!.not_enough_balance);
                              return;
                            }

                            return purchaseHandler.purchaseTopicArtifact(
                              topic: topic,
                              subjectId: subjectId,
                              artifact: artifact,
                              context: context,
                              ref: ref
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonPlan extends StatefulWidget {
  final int index;
  final bool unlocked;
  final bool expanded;
  final List<String> unlockedAssets;
  final ClassTopic topic;
  final Topic baseTopic;
  final Future Function(String artifact, int cost) executeAsset;

  const _LessonPlan({
    required this.unlocked,
    required this.index,
    required this.topic,
    required this.baseTopic,
    required this.expanded,
    required this.unlockedAssets,
    required this.executeAsset,
  });

  @override
  State<_LessonPlan> createState() => _LessonPlanState();
}

class _LessonPlanState extends State<_LessonPlan> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.expanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color(0xFFEAECF0),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.all(0.0),
              shape: const RoundedRectangleBorder(
                side: BorderSide.none,
              ),
            ),
            onPressed: () => setState(() => isExpanded = !isExpanded),
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFFF2F4F7)),
                  top: BorderSide(color: Color(0xFFF2F4F7)),
                  right: BorderSide(color: Color(0xFFF2F4F7)),
                  bottom: BorderSide(width: 1, color: Color(0xFFF2F4F7)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _LessonPlanTag(
                    locked:
                        !widget.unlocked || widget.unlockedAssets.length == 3,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 13),
                        child: Container(
                          decoration: const ShapeDecoration(
                            color: Color(0xFFF2F4F7),
                            shape: CircleBorder(
                              side: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${widget.index}"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.75,
                        child: Text(
                          widget.topic.topic,
                          style: const TextStyle(
                            color: Color(0xFF1D2939),
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () => widget.executeAsset(
                      'quiz',
                      widget.baseTopic.cost.quiz,
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/quiz_icon.svg",
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(AppLocalizations.of(context)!.start_quiz),
                        if (!widget.unlocked &&
                            widget.unlockedAssets.contains('quiz') != true)
                          Text(
                            "${AppLocalizations.of(context)!.use} ${widget.baseTopic.cost.quiz} ${AppLocalizations.of(context)!.xp}",
                            style: const TextStyle(
                              color: Color(0xFFDC6803),
                              fontSize: 10,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () => widget.executeAsset(
                      'case-study',
                      widget.baseTopic.cost.caseStudy,
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/case_study_icon.svg",
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(AppLocalizations.of(context)!.case_study),
                        if (!widget.unlocked &&
                            widget.unlockedAssets.contains('case-study') !=
                                true)
                          Text(
                            "${AppLocalizations.of(context)!.use} ${widget.baseTopic.cost.caseStudy} ${AppLocalizations.of(context)!.xp}",
                            style: const TextStyle(
                              color: Color(0xFFDC6803),
                              fontSize: 10,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () => widget.executeAsset(
                      'materials',
                      widget.baseTopic.cost.materials,
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/study_material_icon.svg",
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(AppLocalizations.of(context)!.study_material),
                        if (!widget.unlocked &&
                            widget.unlockedAssets.contains('materials') != true)
                          Text(
                            "${AppLocalizations.of(context)!.use} ${widget.baseTopic.cost.materials} ${AppLocalizations.of(context)!.xp}",
                            style: const TextStyle(
                              color: Color(0xFFDC6803),
                              fontSize: 10,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LessonPlanTag extends StatelessWidget {
  final bool locked;
  const _LessonPlanTag({required this.locked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 2,
      ),
      decoration: ShapeDecoration(
        color: locked ? const Color(0xFFFDF7C3) : const Color(0xFFD1FADF),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Icon(
              Icons.lock_rounded,
              size: 16,
              color: locked ? const Color(0xFFCA8403) : const Color(0xFF039754),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            locked ? AppLocalizations.of(context)!.locked : AppLocalizations.of(context)!.unlocked,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: locked ? const Color(0xFFCA8403) : const Color(0xFF039754),
              fontSize: 13,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
