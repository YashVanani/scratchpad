import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:video_player/video_player.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
class PlaybookDetailScreen extends StatefulWidget {
  PlaybookDetailScreen({Key? key, required this.playbook}) : super(key: key);
  @override
  _PlaybookDetailScreenState createState() => _PlaybookDetailScreenState();
   
    Playbook playbook;
}


class _PlaybookDetailScreenState extends State<PlaybookDetailScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        widget.playbook.videoUrl??""))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.playbook.title ?? "",
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
                        "Effort level:",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.crisis_alert,
                            color: widget.playbook.effortLevel=='Easy'?Color(0xff16B364):widget.playbook.effortLevel=='Medium'?Colors.orange:Colors.red,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                           widget.playbook.effortLevel??"Easy",
                            style: TextStyle(color: widget.playbook.effortLevel=='Easy'?Color(0xff16B364):widget.playbook.effortLevel=='Medium'?Colors.orange:Colors.red,),
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
                        "Developmental stage:",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                       widget.playbook.stages??"",
                      ),
                    ],
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Focus area",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                      children: [
                        ...( widget.playbook.focusAreas??[]).take(2).map((e) => Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text(e,style: TextStyle(fontSize: 12),))).toList(),
                        (( widget.playbook.focusAreas??[]).length - 2)!=0?Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text('+${( widget.playbook.focusAreas??[]).length - 2}')):SizedBox(),
                    ],)
                    ],
                  )),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                 widget.playbook.desc ??""
                ),
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
                    title: const Text("Activity Toolkit"),
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("Included Material:"),
                      ),
                      ListView(
                        shrinkWrap: true,
                        children:(widget.playbook.materialList??[]).map((e) => PlayBookPDFCard(materialList: e,)).toList(),
                      )
                    ],
                  ),
                ),
              ),
              PlaybookTab(playbook: widget.playbook,),
              _controller!=null?Container(
                margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                height:200,
              child: Stack(
                children: [
                         ClipRRect(borderRadius: BorderRadius.circular(20),child: VideoPlayer(_controller!)),
                 Positioned(
                    top: 80,
                    left: MediaQuery.of(context).size.width*0.40,
                   child: InkWell(
                       onTap: () {
                             setState(() {
                               _controller!.value.isPlaying
                    ? _controller!.pause()
                    : _controller!.play();
                             });
                           },
                           child: Icon(
                             _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                             size: 50,color: Colors.white,
                           ),
                    ),
                 ),
            
                ],
              )
              ):SizedBox(),
              SizedBox(height: 20,)
            ],
          ),
        ));
  }
}

class PlayBookPDFCard extends StatelessWidget {
  PlayBookPDFCard({
    super.key,
    required this.materialList,
  });
  MaterialList materialList;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${materialList.name??""}"),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.download,
            color: Colors.grey,
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
            length: 2,
            child: Column(children: [
              const TabBar(
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
                          Text("Goals")
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
                          Text("Action")
                        ]),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:0.0,vertical: 5),
                child: AutoScaleTabBarView(children: [
                  MarkdownBody(data: playbook.goals??"",),
                 Html(data: playbook.action??"",),
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
