import 'package:clarified_mobile/consts/colors.dart';
import 'package:flutter/material.dart';

class DoubtDetailScreen extends StatefulWidget {
  const DoubtDetailScreen({super.key});

  @override
  State<DoubtDetailScreen> createState() => _DoubtDetailScreenState();
}

class _DoubtDetailScreenState extends State<DoubtDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Geography'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Placeholder(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(children: const [
                  Text(
                    "Teacher Name :",
                    style: TextStyle(
                        color: Color(0xff344054),
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage('assets/man.png'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Mr. John Doe",
                    style: TextStyle(
                        color: Color(0xff1D2939),
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  )
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
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TopicCard(),
                  TopicCard(),
                  TopicCard(),
                  TopicCard(),
                ],
              )
            ],
          ),
        ));
  }
}

class TopicCard extends StatelessWidget {
  const TopicCard({
    super.key,
  });

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
          title: Text("1. Basic Ozone Layer Science"),
          trailing: Icon(
            Icons.lock_open,
            color: Colors.green,
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
