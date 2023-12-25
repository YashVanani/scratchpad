import 'package:clarified_mobile/consts/colors.dart';
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
            ? const Text("Class Survey")
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
                                "Unknown Subject"),
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
                            'Your thoughts and feedback are super valuable',
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Survey Purpose: "),
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
                                "Take a moment to think about the lesson before responding.",
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
                                "Answer truthfully based on your understanding of the lesson.",
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
                                "If there's something you didn't understand, don't hesitate to mention it. ",
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
                                ? "LOADING"
                                : alreadyAnswered == true
                                    ? "ALREADY COMPLETED"
                                    : "START SURVEY",
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
                        return const SizedBox(
                          child: Text("Failed to Previous Answers"),
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
   bool isPeerExist = false;

  @override
  void initState() {
    super.initState();
    questionSaver = ref.read(feedbackManagerProvider(
      (subjectId: widget.subjectId, topicId: widget.topicId),
    ).notifier);
     WidgetsBinding.instance
        .addPostFrameCallback((_) => setPeerSurvey());
     
  }

  void setPeerSurvey()async{
    isPeerExist = await checkPeerSurveyExist(widget.subjectId,ref);
    print("++++PEER++${isPeerExist}");
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
                    const Text(
                      'GOOD JOB!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2970FE),
                        fontSize: 24,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      height: 52,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Happy Learning',
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
                              'Resources for this lesson has unlocked.',
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
                      child: const Text(
                        "OK",
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

            return const Dialog(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text("Submitting Answers"),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      if (value == "finished") Navigator.of(context).maybePop();
      if(isPeerExist){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PeerIntroScreen()));
      }
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ques.type == QuestionType.scq
                    ? SCQAnsewrComponent(
                        answers: tanswers,
                        selectedAnswer: answers[ques.id]?.answer,
                        onAnswerSelected: (answerId) => setState(() {
                          answers[ques.id] = (answer: answerId, extra: "");
                        }),
                      )
                    : ques.type == QuestionType.mcq
                        ? MCQAnsewrComponent(
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
                            ? SliderHAnsewrComponent(
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
                    label: const Text(
                      "Back",
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
                          msg: "Please Select an Answer",
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
                          isLastQuestion ? "Submit" : "Next",
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
