import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/consts/commonStyle.dart';
import 'package:clarified_mobile/consts/imageRes.dart';
import 'package:clarified_mobile/features/peers/model/peers_model.dart';
import 'package:clarified_mobile/features/peers/screens/peer_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PeerIntroScreen extends ConsumerStatefulWidget {
  const PeerIntroScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PeerIntroScreenState();
}

class _PeerIntroScreenState extends ConsumerState<PeerIntroScreen> {
  @override
  Widget build(BuildContext context) {
    final peerSurvey = ref.watch(peerSurveyProvider);
    return Scaffold(
      body: Column(children: [
        SvgPicture.asset('assets/svg/peer_intro.svg'),
        Text(
          'Progress saved',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF475467),
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Time to score your classmates \non how they’re doing!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF12B669),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Text("Instructions:",
                    style: CommonStyle.lexendMediumStyle
                        .copyWith(fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
                child: Text("\u2022 Choose any 3 classmates you know well",
                    style: CommonStyle.lexendMediumStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: greyTextColor)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
                child: Text(
                    "\u2022 Give them star rating based on your observations",
                    style: CommonStyle.lexendMediumStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: greyTextColor)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
                child: Text(
                    "\u2022 Fewer stars = few points; more stars = more points",
                    style: CommonStyle.lexendMediumStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: greyTextColor)),
              )
            ],
          ),
        ),
        Spacer(),
        peerSurvey.when(
            data: (d) => Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: const Color(0xFF04686E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      ref.read(selectedPeerList.notifier).state = [];
                      ref.read(selectedPeerIdList.notifier).state = [];
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PeerSelectScreen(peerSurvey: d,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 36, right: 36),
                      child: Text(
                        "LET’S FINISH THIS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
            error: (e, j) => Text(e.toString()),
            loading: () => SizedBox())
      ]),
    );
  }
}
