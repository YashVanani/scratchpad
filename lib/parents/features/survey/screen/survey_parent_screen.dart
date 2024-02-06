import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/consts/commonStyle.dart';
import 'package:clarified_mobile/consts/imageRes.dart';
import 'package:clarified_mobile/features/home/model/entry.dart';
import 'package:clarified_mobile/features/shared/widgets/page_buttom_slug.dart';
import 'package:clarified_mobile/features/survey/screens/survey_widgets.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/survey_parent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SurveyWizardParentPage extends ConsumerStatefulWidget {
  final String surveyId;
  final Object? extraData;

  const SurveyWizardParentPage({
    super.key,
    required this.surveyId,
    required this.extraData,
  });

  @override
  ConsumerState<SurveyWizardParentPage> createState() => _SurveyWizardParentPageState();
}

class _SurveyWizardParentPageState extends ConsumerState<SurveyWizardParentPage> {
  ParentSurvey? survey;
  int currentQuesIndex = -1;
  bool isCompleted = false;
  final Map<String, ProvidedAnswerParent> answers = {};

  @override
  void initState() {
    super.initState();
    survey = widget.extraData as ParentSurvey;
  }

  void saveCurrentAnswers(bool lastQuestion) async {
    final f = ref.read(surveyAnswerSaverParentProviderParent.notifier).saveAnswer(
          survey: survey!,
          answers: answers,
          completed: lastQuestion,
        );

    if (!lastQuestion) return;

    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: Center(
            child: FutureBuilder(
              future: f,
              builder: (ctxx, snap) {
                if (snap.connectionState == ConnectionState.done) {
                  Navigator.of(ctxx).maybePop();
                  return const SizedBox();
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text(AppLocalizations.of(context)!.submitting_answers),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    setState(() => isCompleted = true);
  }

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return SurveyCompletedParentPage(survey: survey);
    }
    if (currentQuesIndex < 0) {
      return SurveyIntro(
        survey: survey,
        onStartSurvey: () => setState(() => currentQuesIndex = 0),
      );
    } else {
      final ques = survey!.questions[currentQuesIndex];
      final tanswers =
          ques.answers.map((e) => (id: e.id, label: e.label)).toList();
          print(ques.id);
      final isLastQuestion = ques.id == survey!.questions.last.id;

      return Scaffold(
        appBar: AppBar(
          title: Text(survey!.name?.toJson()[Localizations.localeOf(context).languageCode]),
        ),
         body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  child: LinearProgressIndicator(
                    value: (currentQuesIndex + 1) /
                        (survey?.questions.length ?? 1),
                    color: const Color(0xFF2970FE),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffFFFAEB),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                  child: Text(
                    ques.questionText?.toJson()[Localizations.localeOf(context).languageCode],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF344054),
                      fontSize: 18,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.50,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ques.type == QuestionType.scq
                        ? SCQAnsewrComponent(
                            answers: tanswers,
                            selectedAnswer: answers[ques.id]?.answer,
                            onAnswerSelected: (answerId) => setState(() {
                              answers[ques.id] = ProvidedAnswerParent(
                                answer: answerId,
                                extra: ques.answers
                                    .firstWhere((f) => f.id == answerId)
                                    .value,
                              );
                            }),
                          )
                        : ques.type == QuestionType.mcq
                            ? MCQAnsewrComponent(
                                answers: tanswers,
                                selectedAnswers: answers[ques.id]?.answer,
                                onAnswerSelected: (answerIds) => setState(
                                  () {
                                    answers[ques.id] = ProvidedAnswerParent(
                                      answer: answerIds,
                                      extra: answerIds
                                          .map((answerId) => ques.answers
                                              .firstWhere(
                                                (f) => f.id == answerId,
                                              )
                                              .value)
                                          .toList(),
                                    );
                                  },
                                ),
                              )
                            : ques.type == QuestionType.slider_h
                                ? SliderHAnsewrComponent(
                                    answers: tanswers,
                                    selectedAnswer: answers[ques.id]?.answer,
                                    onAnswerSelected: (answerId) => setState(
                                      () {
                                        answers[ques.id] = ProvidedAnswerParent(
                                          answer: answerId,
                                          extra: "",
                                        );
                                      },
                                    ),
                                  )
                                : ques.type == QuestionType.slider_v
                                    ? SliderVAnsewrComponent(
                                        answers: tanswers,
                                        selectedAnswer:
                                            answers[ques.id]?.answer,
                                        onAnswerSelected: (answerId) =>
                                            setState(
                                          () {
                                            answers[ques.id] = ProvidedAnswerParent(
                                              answer: answerId,
                                              extra: "",
                                            );
                                          },
                                        ),
                                      )
                                    : ques.type == QuestionType.boolean
                                        ? BoolAnsewrComponent(
                                            selectedAnswer:
                                                answers[ques.id]?.answer,
                                            onAnswerSelected:
                                                (answerId, comment) => setState(
                                              () {
                                                answers[ques.id] =
                                                    ProvidedAnswerParent(
                                                  answer: answerId,
                                                  extra: comment,
                                                );
                                              },
                                            ),
                                          )
                                        : BoolAnsewrComponent(
                                            hasComment: true,
                                            selectedAnswer:
                                                answers[ques.id]?.answer,
                                            onAnswerSelected:
                                                (answerId, comment) => setState(
                                              () {
                                                answers[ques.id] =
                                                    ProvidedAnswerParent(
                                                  answer: answerId,
                                                  extra: comment,
                                                );
                                              },
                                            ),
                                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.grey,
                          shadowColor: const Color(0x0C101828),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFF2F4F7),
                          ),
                          elevation: 3,
                        ),
                        onPressed: currentQuesIndex == 0
                            ? null
                            : () => setState(() {
                                  currentQuesIndex = currentQuesIndex - 1;
                                }),
                        icon: const Icon(Icons.chevron_left),
                        label: Text(
                          AppLocalizations.of(context)!.back,
                          style: TextStyle(
                            color: Color(0xFF1D2939),
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFF04686E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFF04686E),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {
                          if (answers[ques.id]?.answer == null) {
                            Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)!.please_select_an_answer,
                            );
                            return;
                          }
            
                          saveCurrentAnswers(isLastQuestion);
                          if (isLastQuestion) return;
            
                          setState(() {
                            currentQuesIndex = currentQuesIndex + 1;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              isLastQuestion ? AppLocalizations.of(context)!.submit : AppLocalizations.of(context)!.next,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${AppLocalizations.of(context)!.question} ${currentQuesIndex + 1} ${AppLocalizations.of(context)!.of_text} ${survey?.questions.length}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF98A1B2),
                    fontSize: 10,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: const PageButtomSlug(),
      );
    }
  }
}

class SurveyCompletedParentPage extends StatelessWidget {
  const SurveyCompletedParentPage({
    super.key,
    required this.survey,
  });

  final ParentSurvey? survey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SvgPicture.asset("assets/svg/star.svg"),
            SizedBox(height: 40,),
            Text(
              AppLocalizations.of(context)!.thank_you,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff2970FF),
                fontSize: 24,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20,),
            Text.rich(
              TextSpan(
                children: [
                   TextSpan(
                    text: AppLocalizations.of(context)!.parents_feedback_message,
                    style: TextStyle(
                      color: Color(0xFF1D2939),
                      fontSize: 14,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                 
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const Expanded(child: SizedBox()),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF04686E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFF04686E),
                ),
                elevation: 3,
              ),
              onPressed: () {
                GoRouter.of(context).goNamed("parents-home");
              },
              child: Text(
                AppLocalizations.of(context)!.go_to_home,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const PageButtomSlug(),
    );
  }
}

class SurveyIntro extends ConsumerWidget {
  const SurveyIntro({
    super.key,
    required this.survey,
    required this.onStartSurvey,
  });

  final Function onStartSurvey;
  final ParentSurvey? survey;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final currentChild = ref.watch(myCurrentChild);
    return Scaffold(
      appBar: AppBar(
        title: Text(survey!.name?.toJson()[Localizations.localeOf(context).languageCode]),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),  
                              gradient: LinearGradient(colors: [purpleColor, blueColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            ),
                    padding: const EdgeInsets.only(bottom: 15, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 15,),
                      CircleAvatar(
                                     radius: 22,
                                     backgroundColor: purpleColor,
                                     backgroundImage:
                                         NetworkImage(currentChild?.profileUrl??"",),
                                   ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(currentChild?.name,
                                              style: CommonStyle
                                                  .lexendMediumStyle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          FutureBuilder(
                                              future: getClassroom(
                                                  currentChild?.currentClassId??"", ref),
                                              builder: ((context, snapshot) => Text(
                                                  snapshot.data?.name ?? "",
                                                  style: CommonStyle
                                                      .lexendMediumStyle
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color:
                                                              greyTextColor)))),
                                        ],
                                      ),
                                    ),
                                   
                       
                      ],
                    ),
                  ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Text(AppLocalizations.of(context)!.survey_purpose,style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: survey?.purpose.length??0,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical:5.0),
                    child: Text("\u2022 ${survey?.purpose[index]?.toJson()[Localizations.localeOf(context).languageCode]??""}",style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: greyTextColor)),
                  );
                }),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: TextButton(
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: const Color(0xFF04686E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => onStartSurvey?.call(),
                  child: Text(
                    AppLocalizations.of(context)!.continue_text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const PageButtomSlug(),
    );
  }
}

class QuestionDescriptionParent extends StatelessWidget {
  final String desc;
  const QuestionDescriptionParent({
    super.key,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF15B79E),
                  blurRadius: 2,
                  offset: Offset(1, 2.5),
                  spreadRadius: 5,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.question_description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0E9384),
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 30,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 5.0,
                  ),
                  child: Text(
                    desc,
                    style: const TextStyle(
                      color: Color(0xFF475467),
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(
                    AppLocalizations.of(context)!.close_description,
                    style: TextStyle(
                      color: Color(0xFFD92C20),
                      fontSize: 12,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
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
