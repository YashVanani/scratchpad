import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/consts/imageRes.dart';
import 'package:clarified_mobile/features/home/model/entry.dart';
import 'package:clarified_mobile/parents/models/survey_parent.dart';
import 'package:clarified_mobile/teachers/model/survey.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

class SurveyCardTeacher extends ConsumerWidget {
  const SurveyCardTeacher({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final surveyData = ref.watch(surveyInboxTeacherProvider);
    // return CircularProgressIndicator();
    return SizedBox(
      child: surveyData.when(
        data: (survey) {
          if (survey == null || survey.startAt.isAfter(DateTime.now())) {
            return Container(
              height: 112,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              decoration: ShapeDecoration(
                color: const Color(0xFFFEE4E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svg/no_survey.svg",
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 51,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (survey == null)
                            Text(
                              AppLocalizations.of(context)!.no_survey,
                              style: TextStyle(
                                color: Color(0xFF1D2939),
                                fontSize: 16,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          else ...[
                            Text(
                              AppLocalizations.of(context)!
                                  .your_next_quest_awaits,
                              style: TextStyle(
                                color: Color(0xFF1D2939),
                                fontSize: 16,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/svg/clock.svg"),
                                const SizedBox(width: 8),
                                Text(
                                  '${AppLocalizations.of(context)!.see_you_on} ${survey.startAt.toString().split(" ").first}',
                                  style: const TextStyle(
                                    color: Color(0xFF027A48),
                                    fontSize: 12,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            height: 170,
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [
                  Color(0xFFFAE6A1),
                  Color(0xFFFAE6A1),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16, bottom: 16, left: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          survey.name,
                          style: TextStyle(
                            color: textMainColor,
                            fontSize: 20,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          survey.desc,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: textMainColor,
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Color(0xFFA15B06),
                            ),
                            SizedBox(width: 6,),
                            Text(
                              'Available till : ${survey.endAt
                                      .toString()
                                      .substring(0, 10) ??
                                  ''}',
                              style: TextStyle(
                                color: Color(0xFFA15B06),
                                fontSize: 12,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                        // Container(
                        //   decoration: ShapeDecoration(
                        //     color: Color.fromARGB(255, 245, 234, 199),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //   ),
                        //   child: TextButton(
                        //     onPressed: () => GoRouter.of(context).pushNamed(
                        //       "parent-survey-wizard",
                        //       pathParameters: {"surveyId": survey.id},
                        //       extra: survey,
                        //     ),
                        //     child: Text(
                        //       AppLocalizations.of(context)!.start_now,
                        //       style: TextStyle(
                        //         color: Color(0xFF1D2939),
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w400,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                          child: Image.asset(ImageRes.live)),
                      (survey.imageUrl != null &&
                              (survey.imageUrl?.isNotEmpty ?? false))
                          ? Image.network(
                              survey.imageUrl ?? "",
                              height: 120,
                            )
                          : SvgPicture.asset(
                              "assets/svg/survey_insight.svg",
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (err, st) {
          print([err, st]);
          return Text(err.toString());
        },
        loading: () => const SizedBox(),
      ),
    );
  }
}
