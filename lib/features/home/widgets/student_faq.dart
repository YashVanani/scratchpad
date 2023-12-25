import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/parents/models/faq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class StudentFAQPopUp extends StatefulWidget {
  StudentFAQPopUp({super.key, required this.widgetRef});

  WidgetRef widgetRef;

  @override
  State<StudentFAQPopUp> createState() => _StudentFAQPopUpState();
}

class _StudentFAQPopUpState extends State<StudentFAQPopUp> {
  List<VideoPlayerController?> _controller = [];
  List<bool> isVideoVisible = [];

  // @override
  // void initState() {
  //   _controller = VideoPlayerController.networkUrl(
  //       Uri.parse(widget.playbook.videoUrl ?? ""))
  //     ..initialize().then((_) {
  //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //       setState(() {});
  //     });

  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return AlertDialog(
          scrollable: true,
          iconPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.white,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.frequently_asked_questions,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        child: Icon(Icons.close),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: getFaqs(widget.widgetRef),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data?.studentFaq);
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.studentFaq?.length ?? 0,
                            itemBuilder: (cxt, index) {
                              isVideoVisible.add(false);
                              _controller.add(VideoPlayerController.networkUrl(Uri.parse(snapshot.data?.studentFaq?[index].videoUrl ?? ""))
                                ..initialize().then((_) {
                                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                  setState(() {});
                                }));
                              return ExpansionTile(
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                expandedAlignment: Alignment.topLeft,
                                title: Text(
                                  snapshot.data?.studentFaq?[index].question ?? "",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      snapshot.data?.studentFaq?[index].question ?? "",
                                      style: TextStyle(fontSize: 12, color: Color(0xff475467), fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  snapshot.data?.studentFaq?[index].videoUrl == null || isVideoVisible[index]
                                      ? SizedBox()
                                      : Center(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                isVideoVisible[index] = true;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: greenTextColor,
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                              ),
                                              width: MediaQuery.of(context).size.width * 0.7,
                                              height: 40,
                                              child: Center(
                                                  child: Text(
                                                    AppLocalizations.of(context)!.see_video,
                                                style: TextStyle(color: whiteColor, fontWeight: FontWeight.w500),
                                              )),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  (snapshot.data?.studentFaq?[index].videoUrl != null &&
                                          (snapshot.data?.studentFaq?[index].videoUrl?.isNotEmpty ?? false) &&
                                          isVideoVisible[index])
                                      ? Container(
                                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          height: 200,
                                          child: Stack(
                                            children: [
                                              ClipRRect(borderRadius: BorderRadius.circular(20), child: VideoPlayer(_controller[index]!)),
                                              Positioned(
                                                top: 80,
                                                left: MediaQuery.of(context).size.width * 0.27,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _controller[index]!.value.isPlaying ? _controller[index]!.pause() : _controller[index]!.play();
                                                    });
                                                  },
                                                  child: Icon(
                                                    _controller[index]!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                                    size: 50,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                      : SizedBox(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            });
                      }
                      return SizedBox();
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
