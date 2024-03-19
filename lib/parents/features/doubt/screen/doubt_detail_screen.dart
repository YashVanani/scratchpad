import 'dart:math';

import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final feedback = ref.watch(studentTopicFeedbackProvider);
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(children:  [
                  Text(
                    AppLocalizations.of(context)!.teacher_name,
                    style: const TextStyle(
                        color: Color(0xff344054),
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  const Spacer(),
                 
                  FutureBuilder(future: getTeacherInfo(teacherId, ref), builder: ((context, snapshot) {
                   return Row(
                      children: [
                         CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(snapshot.data?.profileUrl??"",),
                   
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                        Text(snapshot.data?.name??"",
                                               style: const TextStyle(
                            color: Color(0xff1D2939),
                            fontWeight: FontWeight.w400,
                            fontSize: 18),),
                      ],
                    );
                  }))
                  
                 
                ]),
              ),
              const SizedBox(
                height: 6,
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  AppLocalizations.of(context)!.lesson_plan,
                  style: const TextStyle(
                      color: Color(0xff344054),
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ),
              ListView.builder(
                itemCount: subject.topics.length??0,
                itemBuilder: (context, index) =>TopicCard(topic: classSubject.topics[index],feedback: feedback.asData?.value??[],), 
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                
              )
            ],
          ),
        ));
 
  }
}
class TopicCard extends ConsumerWidget{
   TopicCard({
    super.key,
    required this.topic,
    required this.feedback
  });
  ClassTopic topic;
  List<Map> feedback;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if(true){
    //   return Text("${feedback.indexWhere((element) => element['id']==topic.id)} EXIST");
    // }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.black38)
          ),
      child: ExpansionTile(
        shape: Border.all(color: Colors.transparent),
          collapsedShape: Border.all(color: Colors.transparent),
          title: Text(topic.topic),
          trailing: topic.isCompleted? const Icon(
            Icons.lock_open,
            color: Colors.green,
          ):const Icon(
            Icons.lock,
            color: Colors.orange,
          ),
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            decoration: const BoxDecoration(
                                color: Color(0xffFEFBE8),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8))),
                            child: Column(
                              children: [
                                Text(
                                 feedback.indexWhere((element) => element['id']==topic.id)!=-1? (feedback[feedback.indexWhere((element) => element['id']==topic.id)]['answers']['1702518542951']['answer'].toString())??"No feedback":"No feedback",
                                  style: const TextStyle(
                                      color: Color(0xffeaaa08),
                                      fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Understanding",
                                  // AppLocalizations.of(context)!.teaching_pace,
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(width: 30,),
                      Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            decoration: const BoxDecoration(
                                color: Color(0xffF0FDF9),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8))),
                            child: Column(
                              children: [
                                Text(
                                 feedback.indexWhere((element) => element['id']==topic.id)!=-1? feedback[feedback.indexWhere((element) => element['id']==topic.id)]['answers']['1702518504229']['answer']:"No feedback",
                                  style: const TextStyle(
                                      color: Color(0xff15B79E),
                                      fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.teaching_pace,
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                     
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                            decoration: const BoxDecoration(
                                color: Color(0xffEFF4FF),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.sub_topics,
                                  style: const TextStyle(
                                      color: Color(0xff1d2939),
                                      fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                 Text(
                                   feedback.indexWhere((element) => element['id']==topic.id)!=-1? feedback[feedback.indexWhere((element) => element['id']==topic.id)]['answers']['1702518520279']['data'].isNotEmpty?feedback[feedback.indexWhere((element) => element['id']==topic.id)]['answers']['1702518520279']['data']:"No Response":"No feedback",
                                  // "Lorem ipsum dolor sit amet, consectetur adcing elit, sed do eiusmod tempor incididunt ut labore.Lorem .",
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                  ],
                )),
          ]),
    );
  
  }
}
