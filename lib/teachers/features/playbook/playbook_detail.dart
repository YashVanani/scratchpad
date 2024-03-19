import 'package:clarified_mobile/teachers/features/playbook/widgets/playbook_apply.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:clarified_mobile/teachers/model/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:video_player/video_player.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaybookTeacherDetailScreen extends ConsumerStatefulWidget {
  PlaybookTeacherDetailScreen({Key? key, required this.playbook}) : super(key: key);
  @override
  _PlaybookTeacherDetailScreenState createState() => _PlaybookTeacherDetailScreenState();

  Playbook playbook;
}

class _PlaybookTeacherDetailScreenState extends ConsumerState<PlaybookTeacherDetailScreen> {
  VideoPlayerController? _controller;
  
  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.playbook.videoUrl ?? ""))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final teacher = ref.watch(teacherProfileProvider);
  // return Placeholder();
  // }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.pop();
            },
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              // onPressed: () => print("language"),
              onPressed: () {},
              icon: const Icon(
                Icons.translate_outlined,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  widget.playbook.title?.toJson()[Localizations.localeOf(context).languageCode] ?? "",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.effort_level,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.crisis_alert,
                            color: widget.playbook.effortLevel == 'Easy'
                                ? Color(0xff16B364)
                                : widget.playbook.effortLevel == 'Medium'
                                    ? Colors.orange
                                    : Colors.red,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.playbook.effortLevel?.toJson()[Localizations.localeOf(context).languageCode] ?? "Easy",
                            style: TextStyle(
                              color: widget.playbook.effortLevel == 'Easy'
                                  ? Color(0xff16B364)
                                  : widget.playbook.effortLevel == 'Medium'
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.developmental_stage,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: widget.playbook.stages?.map((e)=>Text(
                        e?.toJson()[Localizations.localeOf(context).languageCode] ?? "",
                      )).toList()??[],
                      ),
                    ],
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.focus_area,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          ...(widget.playbook.focusAreas ?? [])
                              .take(2)
                              .map((e) => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 4),
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffEAECF0)),
                                  child: Text(
                                    e?.toJson()[Localizations.localeOf(context).languageCode],
                                    style: TextStyle(fontSize: 12),
                                  )))
                              .toList(),
                          ((widget.playbook.focusAreas ?? []).length - 2) != 0
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 4),
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffEAECF0)),
                                  child: Text(
                                      '+${(widget.playbook.focusAreas ?? []).length - 2}'))
                              : SizedBox(),
                        ],
                      )
                    ],
                  )),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(widget.playbook.desc?.toJson()[Localizations.localeOf(context).languageCode] ?? ""),
              ),
              Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: ()async {
                                 await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PlayBookApply(
                              classId: teacher.asData?.value.classIds??[],
                              playbook: widget.playbook,
                            ); 
                            });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF04686E),
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
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: 
                                     
                                      Text(
                                        // 'LOGIN',
                                        'APPLY THIS STRATEGY',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w400,
                                          height: 0.09,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      

              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    shape: Border.all(color: Colors.transparent),
                    collapsedShape: Border.all(color: Colors.transparent),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    title: Text(AppLocalizations.of(context)!.activity_toolkit),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                            AppLocalizations.of(context)!.included_material),
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: (widget.playbook.materialList ?? [])
                            .map((e) => PlayBookPDFCard(
                                  materialList: e,
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ),
              PlaybookTab(
                playbook: widget.playbook,
              ),
              _controller != null &&
                      (widget.playbook.videoUrl != null &&
                          (widget.playbook.videoUrl?.isNotEmpty ?? false))
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 200,
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: VideoPlayer(_controller!)),
                          Positioned(
                            top: 80,
                            left: MediaQuery.of(context).size.width * 0.40,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _controller!.value.isPlaying
                                      ? _controller!.pause()
                                      : _controller!.play();
                                });
                              },
                              child: Icon(
                                _controller!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ))
                  : SizedBox(),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}
class PlayBookPDFCard extends StatefulWidget {
    PlayBookPDFCard({
    super.key,
    required this.materialList,
  });
  MaterialList materialList;

  @override
  State<PlayBookPDFCard> createState() => _PlayBookPDCardState();
}

class _PlayBookPDCardState extends State<PlayBookPDFCard> {
  bool isDownloading = false;
  @override
  Widget build(BuildContext context) {
   return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${widget.materialList.name ?? ""}"),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () async {
              //You can download a single file
              await FileDownloader.downloadFile(
                  url:widget.materialList.url??"",
                  name: widget.materialList.name?.toJson()[Localizations.localeOf(context).languageCode], //(optional)
                  notificationType: NotificationType.all,
                  onProgress: (fileName, progress) {
                    setState(() {
                      isDownloading=true;
                    });
                  },
                  onDownloadCompleted: (String path) {
                    setState(() {
                       isDownloading=false;
                    });
                    print('FILE DOWNLOADED TO PATH: $path');
                     var snackBar = SnackBar(content: Text('FILE DOWNLOADED TO PATH: $path'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  onDownloadError: (String error) {
                     setState(() {
                       isDownloading=false;
                    });
                    print('DOWNLOAD ERROR: $error');
                        var snackBar = SnackBar(content: Text('DOWNLOAD ERROR: $error'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
            },
            child:isDownloading?CircularProgressIndicator(): Icon(
              Icons.download,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
   }
}

class PlaybookTab extends StatelessWidget {
  PlaybookTab({super.key, required this.playbook});
  Playbook playbook;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
            length: 3,
            child: Column(children: [
              TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flag),
                          SizedBox(
                            width: 5,
                          ),
                          Text(AppLocalizations.of(context)!.goals)
                        ]),
                  ),
                  Tab(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sailing),
                          SizedBox(
                            width: 5,
                          ),
                          Text(AppLocalizations.of(context)!.action)
                        ]),
                  ),
                  Tab(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.help),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Why This Works")
                          // Text(AppLocalizations.of(context)!.action)
                        ]),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: AutoScaleTabBarView(children: [
                  MarkdownBody(
                    data: playbook.goals?.toJson()[Localizations.localeOf(context).languageCode] ?? "",
                  ),
                  Html(
                    data: playbook.action?.toJson()[Localizations.localeOf(context).languageCode] ?? "",
                  ),
                  Text(playbook.whyThisWorks?.toJson()[Localizations.localeOf(context).languageCode] ?? ""),
                  // Column(
                  //   mainAxisSize: MainAxisSize.min,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     //  Text(playbook.action??""),
                  //     //  SizedBox(height: MediaQuery.of(context).size.height*0.5,child: Markdown(data: playbook.action??"",)),
                  //     Html(data: playbook.action??"",),
                  //     // Text("1. Action Steps",style: TextStyle(fontWeight: FontWeight.w500),),
                  //     // Text("Imagine how characters from different backgrounds feel and think. This helps students understand and empathize with diverse experiences."),
                  //     // Text("1. Step into Others' Shoes:",style: TextStyle(fontWeight: FontWeight.w500),),
                  //     // Text("Imagine how characters from different backgrounds feel and think. This helps students understand and empathize with diverse experiences."),
                  //     // Text("1. Step into Others' Shoes:",style: TextStyle(fontWeight: FontWeight.w500),),
                  //     // Text("Imagine how characters from different backgrounds feel and think. This helps students understand and empathize with diverse experiences."),
                  //   ],
                  // ),
                ]),
              )
            ])));
  }
}
