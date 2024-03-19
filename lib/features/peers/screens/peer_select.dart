import 'package:clarified_mobile/features/peers/model/peers_model.dart';
import 'package:clarified_mobile/features/peers/screens/peer_question.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeerSelectScreen extends ConsumerStatefulWidget {
  const PeerSelectScreen({super.key, required this.peerSurvey});
  final PeerSurvey? peerSurvey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PeerSelectScreenState();
}

class _PeerSelectScreenState extends ConsumerState<PeerSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text("Peer Question"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(children: [
          SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 358,
                height: 144,
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/peer_bg.png"),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Select your Friends',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF2F4F7),
                          fontSize: 10,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 326,
                      child: Text(
                        ' Give honest stars just like a real judge! 🌟',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Rate for any 3 class mates',
                style: TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 12,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 14,
              ),
              FutureBuilder(
                  future: classRoomUserListProvider(ref),
                  builder: ((context, snapshot) {
                    print(snapshot.data);
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              
                              if (ref
                                  .read(selectedPeerIdList.notifier)
                                  .state
                                  .contains(snapshot.data?[index].id)) {
                                setState(() {
                                  ref
                                      .read(selectedPeerIdList.notifier)
                                      .state
                                      .remove(snapshot.data?[index].id ?? "");
                                      ref
                                      .read(selectedPeerList.notifier)
                                      .state
                                      .remove(snapshot.data?[index]);
                                });
                              } else {
                                if(ref
                                  .read(selectedPeerIdList.notifier)
                                  .state.length<3){
                                setState(() {
                                  ref
                                      .read(selectedPeerIdList.notifier)
                                      .state
                                      .add(snapshot.data?[index].id ?? "");
                                  ref
                                      .read(selectedPeerList.notifier)
                                      .state
                                      .add(snapshot.data?[index]);
                                });
                                }else{
                                
                var snackBar = SnackBar(content: Text("only 3 class mates you can selected"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                              }
                            },
                            child: StudentCard(
                                index: (index + 1).toString(),
                                student: snapshot.data?[index],
                                isSelected: ref
                                    .read(selectedPeerIdList.notifier)
                                    .state
                                    .contains(snapshot.data?[index].id)),
                          );
                        },
                      );
                    }
                    return SizedBox();
                  }))
            ]),
          ),
        ),
         Visibility(
          visible: ref
                                    .read(selectedPeerIdList.notifier)
                                    .state.length==3,
           child: Positioned(
            bottom: 10,
                   
             child: SizedBox(
              width:MediaQuery.of(context).size.width,
               child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   TextButton(
                     style: TextButton.styleFrom(
                       splashFactory: NoSplash.splashFactory,
                       backgroundColor: const Color(0xFF04686E),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8),
                       ),
                     ),
                     onPressed: ()  {
                        Navigator.pop(context);
                       Navigator.push(context,MaterialPageRoute(builder: (context)=>PeerQuestionScreen(peerSurvey: widget.peerSurvey,)));
                     },
                     child: Container(
                       width: MediaQuery.of(context).size.width*0.6,
                        padding: const EdgeInsets.only( left: 36, right: 36),
                       child: Center(
                         child: Text(
                          "Next",
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
                 ],
               ),
             ),
           ),
         ),
        ],)
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  const StudentCard(
      {super.key,
      required this.index,
      required this.student,
      required this.isSelected});
  final String index;
  final UserInfo? student;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 56,
      margin: EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFEAECF0)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 80,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Text(
                          index,
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                CircleAvatar(
                  radius: 17,
                  backgroundImage: NetworkImage(student?.profileUrl ?? ""),
                ),
                const SizedBox(width: 12),
                Text(
                  student?.name ?? "",
                  style: TextStyle(
                    color: Color(0xFF1D2939),
                    fontSize: 14,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 0.10,
                  ),
                ),
                Spacer(),
                isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      )
                    : SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
