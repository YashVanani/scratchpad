import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/consts/localisedModel.dart';
import 'package:clarified_mobile/features/feedback/model/feedback.dart';
import 'package:clarified_mobile/features/peers/model/peers_model.dart';
import 'package:clarified_mobile/features/peers/screens/peer_intro.dart';
import 'package:clarified_mobile/features/shared/widgets/page_buttom_slug.dart';
import 'package:clarified_mobile/features/survey/screens/survey_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopicFeedbackView extends ConsumerStatefulWidget {
  final String subjectId;
  final String topicId;
  final Map<String, String>? data;

  const TopicFeedbackView({
    super.key,
    required this.subjectId,
    required this.topicId,
    this.data,
  });

  @override
  ConsumerState<TopicFeedbackView> createState() => _TopicFeedbackViewState();
}

class _TopicFeedbackViewState extends ConsumerState<TopicFeedbackView> {
  String mode = "home";

  @override
  Widget build(BuildContext context) {
    final feedbackQuestions = ref.watch(
      feedbackQuestionProvider(
        (topicId: widget.topicId, subjectId: widget.subjectId),
      ),
    );

    final userAlreadyAnswered = ref.watch(
      feedbackManagerProvider(
        (topicId: widget.topicId, subjectId: widget.subjectId),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: mode == "home",
        title: mode == "home"
            ? Text(AppLocalizations.of(context)!.class_survey)
            : Text(
                widget.data?["subjectName"] ?? "",
                textAlign: TextAlign.center,
              ),
      ),
      body: SizedBox.expand(
        child: mode == "home"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: ShapeDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/clazz_survey.png"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8,
                          ),
                          child: Text(
                            (widget.data?["subjectName"]?.toUpperCase() ??
                                AppLocalizations.of(context)!.unknown_subject),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.your_thoughts,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: 12,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(AppLocalizations.of(context)!.survey_purpose),
                  ),
                  // Expanded(
                  //   child: feedbackQuestions.when(
                  //     data: (data) {
                  //       return Markdown(
                  //         data: data.content,
                  //         shrinkWrap: true,
                  //       );
                  //     },
                  //     error: (er, st) {
                  //       print([er, st]);
                  //       return const Center(
                  //         child: Text("Error: Fetching Feedback Questions"),
                  //       );
                  //     },
                  //     loading: () => const SizedBox(),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Row(children: [
                            Image.asset('assets/bullet.png'),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width - 60,
                              child: Text(
                                AppLocalizations.of(context)!.take_a_moment,
                                maxLines: 5,
                                style: const TextStyle(
                                  color: greyTextColor,
                                  fontSize: 14,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ]),
                        ),
                        SizedBox(height: 12,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Row(children: [
                            Image.asset('assets/bullet.png'),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width - 60,
                              child: Text(
                                AppLocalizations.of(context)!.answer_truthfully,
                                maxLines: 5,
                                style: const TextStyle(
                                  color: greyTextColor,
                                  fontSize: 14,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ]),
                        ),
                         SizedBox(height: 12,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Row(children: [
                            Image.asset('assets/bullet.png'),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width - 60,
                              child: Text(
                                AppLocalizations.of(context)!.if_there_something,
                                maxLines: 5,
                                style: const TextStyle(
                                  color: greyTextColor,
                                  fontSize: 14,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: userAlreadyAnswered.when(
                      data: (alreadyAnswered) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: const Color(0xFF04686E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: alreadyAnswered != false
                              ? null
                              : () {
                                  setState(() => mode = "quiz");
                                },
                          child: Text(
                            alreadyAnswered == null
                                ? AppLocalizations.of(context)!.loading
                                : alreadyAnswered == true
                                    ? AppLocalizations.of(context)!.already_completed
                                    : AppLocalizations.of(context)!.start_survey,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      },
                      error: (e, st) {
                        print([e, st]);
                        return SizedBox(
                          child: Text(AppLocalizations.of(context)!.failed_to_previous),
                        );
                      },
                      loading: () => const SizedBox(),
                    ),
                  ),
                ],
              )
            : FeedbackView(
                subjectId: widget.subjectId,
                topicId: widget.topicId,
                topicName: widget.data?["topicName"] ?? "",
              ),
      ),
      bottomNavigationBar: const PageButtomSlug(),
    );
  }
}

class FeedbackView extends ConsumerStatefulWidget {
  final String subjectId;
  final String topicId;
  final String topicName;

  const FeedbackView({
    super.key,
    required this.subjectId,
    required this.topicId,
    required this.topicName,
  });

  @override
  ConsumerState<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends ConsumerState<FeedbackView> {
  int currentQuestion = 0;
  bool isLastQuestion = false;
  Map<String, ({dynamic answer, String extra})> answers = {};
  late FeedbackManager questionSaver;
 

  @override
  void initState() {
    super.initState();
    questionSaver = ref.read(feedbackManagerProvider(
      (subjectId: widget.subjectId, topicId: widget.topicId),
    ).notifier);
  
  }

 
  void saveCurrentAnswers(bool lastQuestion) async {
    final f = questionSaver.saveAnswer(
      answers: answers,
      completed: lastQuestion,
    );

    if (!lastQuestion) return;

    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return FutureBuilder(
          future: f,
          builder: (ctxx, snap) {
            if (snap.connectionState == ConnectionState.done) {
              return Container(
                padding: const EdgeInsets.only(
                  top: 48,
                  left: 24,
                  right: 24,
                  bottom: 24,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 112,
                      height: 48,
                      child: SvgPicture.asset("assets/svg/celebrate.svg"),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.good_job,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2970FE),
                        fontSize: 24,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 52,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.happy_learning,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF344054),
                              fontSize: 16,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            child: Text(
                              AppLocalizations.of(context)!.resources_for_this,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF667085),
                                fontSize: 14,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        backgroundColor: const Color(0xFF04686E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctxx).maybePop("finished");
                      },
                      child: Text(
                        AppLocalizations.of(context)!.ok,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Dialog(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text(AppLocalizations.of(context)!.submitting_answers),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      if (value == "finished") Navigator.of(context).maybePop();
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedbackQuestions = ref.watch(
      feedbackQuestionProvider(
        (topicId: widget.topicId, subjectId: widget.subjectId),
      ),
    );

    final qCount = (feedbackQuestions.valueOrNull?.questions.length ?? 1);
    final ques = feedbackQuestions.value!.questions[currentQuestion];
    final tanswers = ques.answers.map((e) => (id: e, label: e)).toList();
    final isLastQuestion =
        ques.id == feedbackQuestions.valueOrNull?.questions.last.id;
    print("+TANSWER++${tanswers}");
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 390,
              child: Text(
                widget.topicName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 10,
              ),
              child: Slider(
                onChanged: (c) => print(c),
                min: 0,
                max: qCount.toDouble(),
                divisions: qCount,
                value: currentQuestion.toDouble(),
                activeColor: const Color(0xFF36868B),
              ),
            ),
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/feedback_question_banner.png"),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16,
                    ),
                    child: Text(
                      (ques.questionText),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //  // TODO : UNCOMMENT THIS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ques.type == QuestionType.scq
                    ? SCQAnsewrFeedbackComponent(
                        answers: tanswers,
                        selectedAnswer: answers[ques.id]?.answer,
                        onAnswerSelected: (answerId) => setState(() {
                          answers[ques.id] = (answer: answerId, extra: "");
                        }),
                      )
                    : ques.type == QuestionType.mcq
                        ? MCQAnsewrComponentFeedback(
                            answers: tanswers,
                            selectedAnswers: answers[ques.id]?.answer,
                            onAnswerSelected: (answerIds) => setState(
                              () {
                                answers[ques.id] =
                                    (answer: answerIds, extra: "");
                              },
                            ),
                          )
                        : ques.type == QuestionType.sliding
                            ? SliderHAnsewrComponentFeedback(
                                answers: tanswers,
                                selectedAnswer: answers[ques.id]?.answer,
                                onAnswerSelected: (answerId) => setState(
                                  () {
                                    answers[ques.id] =
                                        (answer: answerId, extra: "");
                                  },
                                ),
                              )
                            : ques.type == QuestionType.boolean
                                ? BoolAnsewrComponent(
                                    selectedAnswer: answers[ques.id]?.answer,
                                    onAnswerSelected: (answerId, comment) =>
                                        setState(
                                      () {
                                        answers[ques.id] =
                                            (answer: answerId, extra: comment);
                                      },
                                    ),
                                  )
                                : BoolAnsewrComponent(
                                    hasComment: true,
                                    selectedAnswer: answers[ques.id]?.answer,
                                    onAnswerSelected: (answerId, comment) =>
                                        setState(
                                      () {
                                        answers[ques.id] =
                                            (answer: answerId, extra: comment);
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
                    onPressed: currentQuestion == 0
                        ? null
                        : () => setState(() {
                              currentQuestion = currentQuestion - 1;
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
                        currentQuestion = currentQuestion + 1;
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
          ],
        ),
      ),
    );
  }
}
