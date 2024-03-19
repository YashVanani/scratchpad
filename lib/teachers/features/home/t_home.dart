import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/consts/commonStyle.dart';
import 'package:clarified_mobile/consts/imageRes.dart';
import 'package:clarified_mobile/parents/features/home/widgets/survey_card_parents.dart';
import 'package:clarified_mobile/parents/features/widgets/p_bottombar.dart';
import 'package:clarified_mobile/parents/models/dashboard.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:clarified_mobile/teachers/features/home/widgets/teacher_assistance_card.dart';
import 'package:clarified_mobile/teachers/features/home/widgets/teacher_services_card.dart';
import 'package:clarified_mobile/teachers/features/home/widgets/teacher_survey_card.dart';
import 'package:clarified_mobile/teachers/features/widgets/t_bottombar.dart';
import 'package:clarified_mobile/teachers/model/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TeacherHomeScreen extends ConsumerStatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  ConsumerState<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends ConsumerState<TeacherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(teacherProfileProvider);
    final children = ref.watch(userListProvider);
    final currentChild = ref.watch(myCurrentChild);
    final dashboard = ref.watch(reportDashboardProvider);
    // final childClassroom = ref.watch(childClassroomProvider);
    final favoriteActivity = ref.watch(favoriteActivityProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                        offset: Offset(0.0, 2))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        "${AppLocalizations.of(context)!.hello}\n",
                                    style: CommonStyle.lexendMediumStyle
                                        .copyWith(
                                            fontSize: 12,
                                            color: liteGreenColor)),
                                //TextSpan(text: "Mrs. Smita Gupta", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),

                                profile.when(
                                  data: (u) {
                                    return TextSpan(text: u.name);
                                  },
                                  error: (e, st) {
                                    return TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .error_loading_user);
                                  },
                                  loading: () => const TextSpan(text: "---"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return languageDialog(ref);
                          //     });
                        },
                        icon: const Icon(
                          Icons.translate_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return ParentFAQPopUp(
                          //         widgetRef: ref,
                          //       );
                          //     });
                        },
                        icon: const Icon(
                          Icons.help_outline_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // GoRouter.of(context)
                          //     .pushNamed("parents-notification");
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16,
                      ),
                      child: SurveyCardTeacher(),
                    ),
                   TeacherAssistanceCards(),
                   const SizedBox(height: 20),
                   TeacherServiceCards(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: blueColor,
                            border: Border.all(color: blueBorderColor),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, right: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.community,
                                      style: CommonStyle.lexendMediumStyle
                                          .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .interact_engage,
                                      style: CommonStyle.lexendMediumStyle
                                          .copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    InkWell(
                                      onTap: () {
                                        GoRouter.of(context)
                                            .pushNamed("parents-community");
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            color: darkBlueColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 12),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .open_community,
                                              style: CommonStyle
                                                  .lexendMediumStyle
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                  flex: 2,
                                  child: Image.asset(
                                    ImageRes.groupUserImage,
                                    fit: BoxFit.fill,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const TeachersBottomBar(
        selected: 'teachers-home',
      ),
    );
  }

}