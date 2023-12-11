import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class DoubtDetailScreen extends ConsumerWidget{
  DoubtDetailScreen({
    super.key,
    required this.teacherId,
    required this.subject,
    required this.classSubject
  });
  ClassSubject classSubject;
  Subject subject;
  String teacherId;
    @override
  Widget build(BuildContext context,WidgetRef ref) {
    
    // final subjectItem = ref.watch(subjectItemProvider(subject.teacherId));
    
    final teacherData = ref.watch(teacherInfo(teacherId));
     return Scaffold(
        appBar: AppBar(
          title: Text(subject.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Image.network(subject.bannerImage,fit: BoxFit.cover,),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(children:  [
                  Text(
                    "Teacher Name :",
                    style: TextStyle(
                        color: Color(0xff344054),
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  Spacer(),
                 
                  FutureBuilder(future: getTeacherInfo(teacherId, ref), builder: ((context, snapshot) {
                   return Row(
                      children: [
                         CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(snapshot.data?.profileUrl??"",),
                   
                  ),
                  SizedBox(
                    width: 10,
                  ),
                        Text(snapshot.data?.name??"",
                                               style: TextStyle(
                            color: Color(0xff1D2939),
                            fontWeight: FontWeight.w400,
                            fontSize: 18),),
                      ],
                    );
                  }))
                  
                 
                ]),
              ),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  "Lesson Plan",
                  style: TextStyle(
                      color: Color(0xff344054),
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ),
              ListView.builder(
                itemCount: subject.topics.length??0,
                itemBuilder: (context, index) =>TopicCard(topic: classSubject.topics[index],), 
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                
              )
            ],
          ),
        ));
 
  }
}

class TopicCard extends StatelessWidget {
  TopicCard({
    super.key,
    required this.topic
  });
  ClassTopic topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.black38)
          ),
      child: ExpansionTile(
        shape: Border.all(color: Colors.transparent),
          collapsedShape: Border.all(color: Colors.transparent),
          title: Text(topic.topic),
          trailing: topic.isCompleted? Icon(
            Icons.lock_open,
            color: Colors.green,
          ):Icon(
            Icons.lock,
            color: Colors.orange,
          ),
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            child: Column(
                              children: [
                                Text(
                                  "MEDIUM",
                                  style: TextStyle(
                                      color: Color(0xffeaaa08),
                                      fontSize: 17),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Teaching Pace",
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xffFEFBE8),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8))),
                          ),
                        ),
                      SizedBox(width: 30,),
                      Expanded(
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            child: Column(
                              children: [
                                Text(
                                  "GOOD",
                                  style: TextStyle(
                                      color: Color(0xff15B79E),
                                      fontSize: 17),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Teaching Pace",
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xffF0FDF9),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8))),
                          ),
                        ),
                     
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                            padding:
                                EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SUB-TOPICS",
                                  style: TextStyle(
                                      color: Color(0xff1d2939),
                                      fontSize: 17),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Lorem ipsum dolor sit amet, consectetur adcing elit, sed do eiusmod tempor incididunt ut labore.Lorem .",
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xffEFF4FF),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8))),
                          ),
                  ],
                )),
          ]),
    );
  }
}
