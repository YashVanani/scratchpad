import 'dart:async';
import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clarified_mobile/features/survey/screens/survey_widgets.dart';
import 'package:clarified_mobile/features/shared/widgets/page_buttom_slug.dart';
import 'package:clarified_mobile/features/subjects/model/quiz_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuizWizardPage extends ConsumerStatefulWidget {
  final String subjectId;
  final String topicId;
  final String topicName;
  final String subjectName;

  const QuizWizardPage({
    super.key,
    required this.subjectId,
    required this.topicId,
    required this.topicName,
    required this.subjectName,
  });

  @override
  ConsumerState<QuizWizardPage> createState() => _QuizWizardPageState();
}

class _QuizWizardPageState extends ConsumerState<QuizWizardPage> {
  int next = 0;
  String selectedLevel = "easy";
  bool startQuiz = false;

  @override
  Widget build(BuildContext context) {
    final quiz = ref.watch(
      quizProvider(
        (
          subjectId: widget.subjectId,
          topicId: widget.topicId,
          type: "quiz",
        ),
      ),
    );

    return startQuiz
        ? QuizView(
            quiz: quiz.value!,
            level: selectedLevel,
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.subjectName),
            ),
            body: IndexedStack(
              index: next,
              children: [
                QuizWelcomeScreen(
                  subjectId: widget.subjectId,
                  topicId: widget.topicId,
                  topicName: widget.topicName,
                  onNext: () => setState(() => next = 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 16),
                        child: Text(
                          "Select Difficulty Level",
                          style: TextStyle(
                            color: Color(0xFF1D2939),
                            fontSize: 20,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SPChecker(
                          items: [
                            (
                              label: "Easy",
                              onClicked: () =>
                                  setState(() => selectedLevel = "easy")
                            ),
                            (
                              label: "Medium ",
                              onClicked: () =>
                                  setState(() => selectedLevel = "medium")
                            ),
                            (
                              label: "Hard",
                              onClicked: () =>
                                  setState(() => selectedLevel = "hard")
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          backgroundColor: const Color(0xFF04686E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() => startQuiz = true);
                        },
                        child: const Text(
                          "CONTINUE",
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
                ),
              ],
            ),
            bottomNavigationBar: const PageButtomSlug(),
          );
  }
}

class QuizWelcomeScreen extends StatelessWidget {
  const QuizWelcomeScreen({
    super.key,
    required this.subjectId,
    required this.topicId,
    required this.topicName,
    required this.onNext,
  });

  final String subjectId;
  final String topicId;
  final String topicName;
  final Function onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF073BA5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: SvgPicture.asset("assets/svg/quiz_time.svg"),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                border: Border(
                  left: BorderSide(color: Color(0xFFEAECF0)),
                  top: BorderSide(width: 1, color: Color(0xFFEAECF0)),
                  right: BorderSide(color: Color(0xFFEAECF0)),
                  bottom: BorderSide(color: Color(0xFFEAECF0)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    topicName,
                    style: const TextStyle(
                      color: Color(0xFF155DEE),
                      fontSize: 24,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Complete and get ',
                              style: TextStyle(
                                color: Color(0xFF344054),
                                fontSize: 16,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '+100 XP',
                              style: TextStyle(
                                color: Color(0xFFEAA907),
                                fontSize: 16,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 140,
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 24,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF5F8FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Quiz Goals :',
                              style: TextStyle(
                                color: Color(0xFF0040C1),
                                fontSize: 10,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'We value your input and strive to enhance your learning experience. The purpose of this survey is to gather Quiz on the recently completed lesson. Your responses will help us understand.',
                            style: TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 12,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: const Color(0xFF04686E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => onNext(),
                    child: const Text(
                      "CONTINUE",
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
            ),
          ),
        ],
      ),
    );
  }
}

class SPChecker extends StatefulWidget {
  final List<({String label, Function onClicked})> items;

  const SPChecker({
    super.key,
    required this.items,
  });

  @override
  State<SPChecker> createState() => _SPCheckerState();
}

class _SPCheckerState extends State<SPChecker> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: widget.items.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (BuildContext context, int index) {
        final item = widget.items[index];
        return InkWell(
          onTap: () {
            setState(() {
              selected = index;
            });
            item.onClicked();
          },
          child: Container(
            padding: const EdgeInsets.only(
              top: 16,
              left: 24,
              right: 16,
              bottom: 16,
            ),
            decoration: ShapeDecoration(
              color: const Color(0xFFFCFCFD),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFF83ADFF),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF84ADFF),
                  blurRadius: 0,
                  offset: Offset(0, 3),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cell_tower_sharp,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      color: Color(0xFF045E63),
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                if (selected == index)
                  const Icon(Icons.check_rounded, color: Color(0xFF83ADFF))
              ],
            ),
          ),
        );
      },
    );
  }
}

class QuizView extends ConsumerStatefulWidget {
  final String level;
  final Quiz quiz;

  const QuizView({
    super.key,
    required this.level,
    required this.quiz,
  });

  @override
  ConsumerState<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends ConsumerState<QuizView> {
  int currentQuestion = 0;
  bool isLastQuestion = false;
  Map<String, ({dynamic answer, String extra, bool isCorrect})> answers = {};
  List<QuizQuestion> activeQuestions = [];
  final emitter = EventEmitter();

  final startAt = DateTime.now();

  bool pauseTimer = false;
  // late QuizManager questionSaver;

  @override
  void initState() {
    super.initState();

    activeQuestions =
        widget.quiz.questions.where((q) => q.level == widget.level).toList();
    // questionSaver = ref.read(QuizManagerProvider(
    //     (subjectId: widget.subjectId, topicId: widget.topicId)).notifier);
  }

  void saveCurrentAnswers(bool lastQuestion) async {
    // final f = questionSaver.saveAnswer(
    //   answers: answers,
    //   completed: lastQuestion,
    // );

    // if (!lastQuestion) return;

    // await showModalBottomSheet(
    //   context: context,
    //   builder: (ctx) {
    //     return FutureBuilder(
    //       future: f,
    //       builder: (ctxx, snap) {
    //         if (snap.connectionState == ConnectionState.done) {
    //           return Container(
    //             padding: const EdgeInsets.only(
    //               top: 48,
    //               left: 24,
    //               right: 24,
    //               bottom: 24,
    //             ),
    //             clipBehavior: Clip.antiAlias,
    //             decoration: ShapeDecoration(
    //               color: Colors.white,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(16),
    //               ),
    //             ),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 SizedBox(
    //                   width: 112,
    //                   height: 48,
    //                   child: SvgPicture.asset("assets/svg/celebrate.svg"),
    //                 ),
    //                 const SizedBox(height: 16),
    //                 const Text(
    //                   'GOOD JOB!',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                     color: Color(0xFF2970FE),
    //                     fontSize: 24,
    //                     fontFamily: 'Lexend',
    //                     fontWeight: FontWeight.w600,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 16),
    //                 const SizedBox(
    //                   height: 52,
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       Text(
    //                         'Happy Learning',
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                           color: Color(0xFF344054),
    //                           fontSize: 16,
    //                           fontFamily: 'Lexend',
    //                           fontWeight: FontWeight.w400,
    //                         ),
    //                       ),
    //                       SizedBox(height: 8),
    //                       SizedBox(
    //                         child: Text(
    //                           'Resources for this lesson has unlocked.',
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                             color: Color(0xFF667085),
    //                             fontSize: 14,
    //                             fontFamily: 'Lexend',
    //                             fontWeight: FontWeight.w400,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const SizedBox(height: 16),
    //                 TextButton(
    //                   style: TextButton.styleFrom(
    //                     splashFactory: NoSplash.splashFactory,
    //                     backgroundColor: const Color(0xFF04686E),
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(8),
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     Navigator.of(ctxx).maybePop("finished");
    //                   },
    //                   child: const Text(
    //                     "OK",
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 14,
    //                       fontFamily: 'Lexend',
    //                       fontWeight: FontWeight.w400,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         }

    //         return const Dialog(
    //           child: Center(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 CircularProgressIndicator(),
    //                 Text("Submitting Answers"),
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // ).then((value) {
    //   if (value == "finished") Navigator.of(context).maybePop();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final ques = activeQuestions[currentQuestion];
    final tanswers = ques.answers.map((e) => (id: e, label: e)).toList();
    final isLastQuestion = ques.id == activeQuestions.last.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              // color: Colors.white,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
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
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Playing Quiz",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF475467),
                        fontSize: 22,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TimerProgressBar(
                    shouldPause: pauseTimer,
                    total: Duration(seconds: widget.quiz.duration),
                    emitter: emitter,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Total Question: ",
                      children: [
                        TextSpan(
                          text: "${activeQuestions.length}",
                          style: const TextStyle(
                            color: Color(0xFF1D2939),
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Answered: ",
                      children: [
                        TextSpan(
                          text:
                              "${(answers.keys.length - 1).clamp(0, answers.keys.length)}",
                          style: const TextStyle(
                            color: Color(0xFF087343),
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Remaining: ",
                      children: [
                        TextSpan(
                          text:
                              "${(activeQuestions.length - answers.keys.length - 1).clamp(0, activeQuestions.length)}",
                          style: const TextStyle(
                            color: Color(0xFFCA8403),
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              constraints: const BoxConstraints(
                minHeight: 150,
              ),
              decoration: ShapeDecoration(
                gradient: const SweepGradient(
                  colors: [
                    Color(0xffecd9d9),
                    Color(0xffd2e9fb),
                    Color(0xffede9db)
                  ],
                  stops: [0.25, 0.55, 0.87],
                  center: Alignment.topRight,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Question: ${currentQuestion + 1}"),
                    Text(
                      ques.questionText,
                      // textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SCQAnsewrComponent(
                  answers: tanswers,
                  selectedAnswer: answers[ques.id]?.answer,
                  onAnswerSelected: (submittedAnswer) => setState(() {
                    answers[ques.id] = (
                      answer: submittedAnswer,
                      extra: "",
                      isCorrect: submittedAnswer == ques.answer
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton(
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
                onPressed: () async {
                  if (answers[ques.id]?.answer == null) {
                    Fluttertoast.showToast(
                      msg: "Please Select an Answer",
                    );
                    return;
                  }

                  saveCurrentAnswers(isLastQuestion);
                  if (isLastQuestion) {
                    emitter.on("timier:stopped", null, (ev, context) {
                      //ev.data as string
                    });
                    emitter.emit("stop:timer");
                    setState(() => pauseTimer = true);
                  }
                  ;
                  await (() async {
                    await showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        isDismissible: false,
                        shape: const ContinuousRectangleBorder(
                          side: BorderSide.none,
                        ),
                        builder: (ctx) {
                          if (isLastQuestion) {
                            final correctCount = answers.values
                                    .where((e) => e.isCorrect)
                                    .length /
                                activeQuestions.length;
                            return CompletePopUp(
                              successPercent: "${(correctCount * 100).ceil()}",
                              elaspsedTime: '',
                              pointsGained: "${widget.quiz.points}",
                            );
                          }
                          return SubmittedAnswer(
                            question: ques,
                            answer: answers[ques.id]!.answer,
                          );
                        });
                  })();

                  if (isLastQuestion) return;

                  setState(() {
                    currentQuestion = currentQuestion + 1;
                  });
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const PageButtomSlug(),
    );
  }
}

class TimerProgressBar extends StatefulWidget {
  final Duration total;
  final bool shouldPause;
  final EventEmitter emitter;

  const TimerProgressBar({
    super.key,
    required this.total,
    required this.shouldPause,
    required this.emitter,
  });

  @override
  State<TimerProgressBar> createState() => _TimerProgressBarState();
}

class _TimerProgressBarState extends State<TimerProgressBar> {
  late Stream<int> _ticker;
  int elapsed = 0;
  StreamSubscription<int>? sub;

  @override
  void initState() {
    super.initState();
    _ticker = Stream.periodic(
      const Duration(seconds: 1),
      (idx) => idx,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sub = _ticker.listen((event) => setState(() => elapsed = event));
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (oldWidget.shouldPause != widget.shouldPause) {
      final isPaused = sub?.isPaused == true;
      isPaused == true ? sub?.resume() : sub?.pause();
      if (isPaused) {
        final e = widget.emitter;
        Future.delayed(
          const Duration(milliseconds: 100),
          () {
            e.emit(
              "current:time",
              null,
              formatDuration(Duration(seconds: elapsed)),
            );
          },
        );
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  String formatDuration(Duration dur) {
    final minVal = dur.inMinutes.toString();
    final secVal = (dur.inSeconds % 60).toString();

    return "${minVal.padLeft(2, '0')}:${secVal.padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              formatDuration(Duration(seconds: elapsed)),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LinearProgressIndicator(
                value: elapsed / widget.total.inSeconds,
                color: const Color(0xFF2970FE),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatDuration(widget.total),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class SubmittedAnswer extends StatefulWidget {
  final QuizQuestion question;
  final String answer;

  const SubmittedAnswer({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<SubmittedAnswer> createState() => _SubmittedAnswerState();
}

class _SubmittedAnswerState extends State<SubmittedAnswer> {
  bool allowClose = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()async{
       return  allowClose;
      },
      // canPop: allowClose,
      // onPopInvoked: (bo) => print("poped $bo"),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Correct Answer : ${widget.question.answer}',
                style: const TextStyle(
                  color: Color(0xFF344054),
                  fontSize: 14,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (widget.question.answerComment.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF6FEFC),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color(0xFFCCFBEF),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.question.answerComment,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF0E9384),
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: const Color(0xFFF9FAFB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: Text(
                            'Explanation : ',
                            style: TextStyle(
                              color: Color(0xFFEAA907),
                              fontSize: 14,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.lightbulb,
                          color: Color(0xFFEAAA08),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.question.explanation,
                      style: const TextStyle(
                        color: Color(0xFF475467),
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton(
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
                onPressed: () async {
                  setState(() {
                    allowClose = true;
                  });
                  Navigator.of(context).maybePop();
                },
                child: const Text(
                  "NEXT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompletePopUp extends StatelessWidget {
  final String successPercent;
  final String elaspsedTime;
  final String pointsGained;

  const CompletePopUp({
    super.key,
    required this.successPercent,
    required this.elaspsedTime,
    required this.pointsGained,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 156,
            child: Center(
              child: SvgPicture.asset("assets/svg/celebrate.svg"),
            ),
          ),
          const SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Lesson Quiz Complete!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1D2939),
                    fontSize: 24,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You are doing great.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 14,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 2,
                      right: 2,
                      bottom: 2,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFAC414),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'EARNED XP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/crown.svg",
                                    theme: const SvgTheme(
                                      currentColor: Color(0xFFFDB022),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+$pointsGained',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFFFDB022),
                                      fontSize: 14,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w600,
                                      height: 0.10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 2,
                      right: 2,
                      bottom: 2,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF15B79E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'TIME',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Icon(
                                      Icons.timelapse_sharp,
                                      color: Color(0xFF15B79E),
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    elaspsedTime,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFF15B79E),
                                      fontSize: 14,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w600,
                                      height: 0.10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 2,
                      right: 2,
                      bottom: 2,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF12B669),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'PERFECT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Icon(
                                      Icons.graphic_eq_sharp,
                                      color: Color(0xFF12B669),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$successPercent%',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFF12B669),
                                      fontSize: 14,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w600,
                                      height: 0.10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: OutlinedButton(
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
              onPressed: () async {},
              child: const Text(
                "CONTINUE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const PageButtomSlug()
        ],
      ),
    );
  }
}
