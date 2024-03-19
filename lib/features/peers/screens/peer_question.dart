import 'dart:math';

import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/features/peers/model/peers_model.dart';
import 'package:clarified_mobile/features/peers/screens/peer_select.dart';
import 'package:clarified_mobile/features/survey/screens/survey_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PeerQuestionScreen extends ConsumerStatefulWidget {
  const PeerQuestionScreen({super.key, required this.peerSurvey});
  final PeerSurvey? peerSurvey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PeerQuestionScreenState();
}

class _PeerQuestionScreenState extends ConsumerState<PeerQuestionScreen> {
  int currentQuestion = 0;
  bool isLastQuestion = false;
  Map<String, ({dynamic answer, String extra})> answers = {};
  late PeerManager questionSaver;
  bool isPeerExist = false;
  Map<String, Map<String, double>> answerMap = {};
  bool isCompleted = false;
  List<double> value = [0, 0, 0];
  @override
  void initState() {
     isCompleted = false;
    super.initState();
    questionSaver = ref.read(peerManagerProvider(
      (
        surveyId: ref.read(currentSurveyId.notifier).state,
        peerId: ref.read(currentPeerSurveyId.notifier).state
      ),
    ).notifier);
  }

  void addOrUpdateAnswer(String quesId, String studId, double value) {
    // Check if the quesId exists in the map
    if (answerMap.containsKey(quesId)) {
      // Update existing answer for the given studId
      print('Updating answer for studId $studId in quesId $quesId');
      answerMap[quesId]?[studId] = value;
    } else {
      // quesId doesn't exist, create a new entry
      print('quesId $quesId does not exist. Creating a new entry.');
      answerMap[quesId] = {studId: value};
    }
  }

  void saveCurrentAnswers(bool lastQuestion) async {
    final f = questionSaver.saveAnswer(
      answers: answerMap,
      completed: lastQuestion,
    );

    if (!lastQuestion) return;
    setState(() {
      isCompleted = true;
    });
   
  }

  @override
  Widget build(BuildContext context) {
    final qCount = (widget.peerSurvey?.questions?.length ?? 1);
    final ques = widget.peerSurvey?.questions?[currentQuestion];
    final tanswers = ques ?? [].map((e) => (id: e, label: e)).toList();
    final isLastQuestion =
        ((ques?.id ?? "") == (widget.peerSurvey?.questions?.last.id)) ?? true;
    List tempA = [];
 if (isCompleted ) {
      return SurveyCompletedPage(
        survey: null,
        isPeerExist: isPeerExist,
      );
    }
    
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 390,
                  child: Text(
                    'Peer Survey',
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
                          (ques?.questionText ?? ""),
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16,
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          ref.watch(selectedPeerList.notifier).state.length,
                      itemBuilder: (context, i) {
                      
                        return ExpansionTile(
                          initiallyExpanded: true,
                          shape: Border(),
                          trailing: SizedBox.shrink(),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StudentCard(
                                  index: (i + 1).toString(),
                                  student: ref
                                      .watch(selectedPeerList.notifier)
                                      .state[i],
                                  isSelected: false),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:45.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RatingBar(
                                      initialRating: value[i],
                                      allowHalfRating: false,
                                      ratingWidget: RatingWidget(
                                          full: Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                          half: Icon(
                                            Icons.star_half,
                                            color: Colors.yellow,
                                          ),
                                          empty: Icon(
                                            Icons.star_outline,
                                            color: Colors.grey,
                                          )),
                                      onRatingUpdate: (d) {
                                        setState(() {
                                          addOrUpdateAnswer(
                                              ques?.id ?? '',
                                              ref
                                                      .watch(selectedPeerList.notifier)
                                                      .state[i]
                                                      ?.id ??
                                                  "",
                                              d);
                                          value[i] = d;
                                        });
                                      }),
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                ),
               
                 Container(
            width: MediaQuery.of(context).size.width-48,
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            decoration: ShapeDecoration(
              color: Color(0xFFF5FBFB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Icon(Icons.info,color: greenTextColor,),
                const SizedBox(width: 16),
                Text(
                  '1 being not at all, 5 being completely',
                  style: TextStyle(
                    color: Color(0xFF475467),
                    fontSize: 14,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 0.10,
                  ),
                ),
              ],
            ),
          ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width-32,
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
                            print(answerMap);
                              
                            answers[ques?.id ?? ''] =
                                (answer: answerMap, extra: '');
                            if (answers[ques?.id]?.answer == null) {
                              Fluttertoast.showToast(
                                msg: "Please Select an Answer",
                              );
                              return;
                            }
                              
                            saveCurrentAnswers(isLastQuestion);
                            if (isLastQuestion) return;
                            for (int i = 0; i < value.length; i++) {
                              setState(() {
                                value[i] = 0;
                              });
                            }
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
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
