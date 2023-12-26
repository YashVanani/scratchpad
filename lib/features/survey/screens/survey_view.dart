import 'package:clarified_mobile/features/home/model/entry.dart';
import 'package:clarified_mobile/features/peers/model/peers_model.dart';
import 'package:clarified_mobile/features/peers/screens/peer_intro.dart';
import 'package:clarified_mobile/features/shared/widgets/page_buttom_slug.dart';
import 'package:clarified_mobile/features/survey/screens/survey_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
class SurveyWizardPage extends ConsumerStatefulWidget {
  final String surveyId;
  final Object? extraData;

  const SurveyWizardPage({
    super.key,
    required this.surveyId,
    required this.extraData,
  });

  @override
  ConsumerState<SurveyWizardPage> createState() => _SurveyWizardPageState();
}

class _SurveyWizardPageState extends ConsumerState<SurveyWizardPage> {
  Survey? survey;
  int currentQuesIndex = -1;
  bool isCompleted = false;
  final Map<String, ProvidedAnswer> answers = {};
   bool isPeerExist = false;

  @override
  void initState() {
    super.initState();
    survey = widget.extraData as Survey;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setPeerSurvey());
     
  }
 void setPeerSurvey()async{
    isPeerExist = await checkPeerSurveyExist(widget.surveyId,ref);
    print("++++PEER++${isPeerExist}");
  }

 

  void saveCurrentAnswers(bool lastQuestion) async {
    final f = ref.read(surveyAnswerSaverProvider.notifier).saveAnswer(
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
    if (isCompleted ) {
      return SurveyCompletedPage(survey: survey,isPeerExist: isPeerExist,);
    }
   
    if (currentQuesIndex < 0) {
      return SurveyIntro(
        survey: survey,
        onStartSurvey: () => setState(() => currentQuesIndex = 0),
      );
    } else {
      final ques = survey!.questions[currentQuesIndex];
      final tanswers = ques.answers.map((e) => (id: e.id, label: e.label)).toList();
      final isLastQuestion = ques.id == survey!.questions.last.id;

      return Scaffold(
        appBar: AppBar(
          title: Text(survey!.name),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_survey_q.png"),
                fit: BoxFit.cover,
              ),
            ),
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
                    value: (currentQuesIndex + 1) / (survey?.questions.length ?? 1),
                    color: const Color(0xFF2970FE),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 10,
                    bottom: 6,
                  ),
                  child: Text(
                    ques.questionText,
                    style: const TextStyle(
                      color: Color(0xFF344054),
                      fontSize: 18,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Center(
                  child: OutlinedButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) {
                          print(ques.description);
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            child: QuestionDescription(
                              desc: ques.description,
                            ),
                          );
                        }),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey,
                      shadowColor: const Color(0x0C101828),
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xFFF2F4F7),
                      ),
                      elevation: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.see_description,
                          style: TextStyle(
                            color: Color(0xFF475467),
                            fontSize: 10,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right_rounded)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ques.type == QuestionType.scq
                        ? SCQAnsewrComponent(
                            answers: tanswers,
                            selectedAnswer: answers[ques.id]?.answer,
                            onAnswerSelected: (answerId) => setState(() {
                              answers[ques.id] = ProvidedAnswer(
                                answer: answerId,
                                extra: ques.answers.firstWhere((f) => f.id == answerId).value,
                              );
                            }),
                          )
                        : ques.type == QuestionType.mcq
                            ? MCQAnsewrComponent(
                                answers: tanswers,
                                selectedAnswers: answers[ques.id]?.answer,
                                onAnswerSelected: (answerIds) => setState(
                                  () {
                                    answers[ques.id] = ProvidedAnswer(
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
                                        answers[ques.id] = ProvidedAnswer(
                                          answer: answerId,
                                          extra: "",
                                        );
                                      },
                                    ),
                                  )
                                : ques.type == QuestionType.slider_v
                                    ? SliderVAnsewrComponent(
                                        answers: tanswers,
                                        selectedAnswer: answers[ques.id]?.answer,
                                        onAnswerSelected: (answerId) => setState(
                                          () {
                                            answers[ques.id] = ProvidedAnswer(
                                              answer: answerId,
                                              extra: "",
                                            );
                                          },
                                        ),
                                      )
                                    : ques.type == QuestionType.boolean
                                        ? BoolAnsewrComponent(
                                            selectedAnswer: answers[ques.id]?.answer,
                                            onAnswerSelected: (answerId, comment) => setState(
                                              () {
                                                answers[ques.id] = ProvidedAnswer(
                                                  answer: answerId,
                                                  extra: comment,
                                                );
                                              },
                                            ),
                                          )
                                        : BoolAnsewrComponent(
                                            hasComment: true,
                                            selectedAnswer: answers[ques.id]?.answer,
                                            onAnswerSelected: (answerId, comment) => setState(
                                              () {
                                                answers[ques.id] = ProvidedAnswer(
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
                      SizedBox(
                        height: 60,
                        width:60,
                        child: Image.network(ques.characterImg??"",fit: BoxFit.cover,),
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

class SurveyCompletedPage extends StatelessWidget {
  const SurveyCompletedPage({
    super.key,
    required this.survey,
    required this.isPeerExist
  });

  final Survey? survey;
  final bool isPeerExist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset("assets/svg/survey_completed.svg"),
            Text(
              AppLocalizations.of(context)!.congratulation,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1D2939),
                fontSize: 24,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.you_earned,
                    style: TextStyle(
                      color: Color(0xFF1D2939),
                      fontSize: 18,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${survey?.startAt.add(Duration(days: 1)).isAfter(DateTime.now()) ?? false ? survey?.reward : ((survey?.reward ?? 0) * 0.5).toInt()} ${AppLocalizations.of(context)!.xp}',
                    style: const TextStyle(
                      color: Color(0xFFFEC84B),
                      fontSize: 18,
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
                
                if(isPeerExist){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PeerIntroScreen()));
      }else{
        GoRouter.of(context).goNamed("home");
      }
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

class SurveyIntro extends StatelessWidget {
  const SurveyIntro({
    super.key,
    required this.survey,
    required this.onStartSurvey,
  });

  final Function onStartSurvey;
  final Survey? survey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  decoration:  BoxDecoration(
                    image: (survey?.thumbnail?.isEmpty)??true? DecorationImage(
                      image: AssetImage("assets/survey_bg.png"),
                      fit: BoxFit.cover,
                    ):DecorationImage(
                      image:NetworkImage(survey?.thumbnail??""),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const SizedBox(),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        survey?.name ?? AppLocalizations.of(context)!.unknown,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF1D2939),
                          fontSize: 24,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          child: Markdown(
                            data: survey?.desc ?? "",
                            shrinkWrap: true,
                            styleSheet: MarkdownStyleSheet(),
                            // textAlign: TextAlign.center,
                            // style: const TextStyle(
                            //   color: Color(0xFF1D2939),
                            //   fontSize: 12,
                            //   fontFamily: 'Lexend',
                            // ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "'⏰ ${AppLocalizations.of(context)!.theres_no_time_limit_respond_at_your_own_pace}'",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF101828),
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/crown.svg",
                              theme: const SvgTheme(
                                currentColor: Color(0xFFFAC515),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!.complete_and_get,
                                    style: TextStyle(
                                      color: Color(0xFF344054),
                                      fontSize: 16,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '+${survey?.startAt.add(Duration(days: 1)).isAfter(DateTime.now()) ?? false ? survey?.reward : ((survey?.reward ?? 0) * 0.5).toInt()} ${AppLocalizations.of(context)!.xp}',
                                    style: const TextStyle(
                                      color: Color(0xFFEAA907),
                                      fontSize: 16,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

class QuestionDescription extends StatelessWidget {
  final String desc;

  const QuestionDescription({
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
