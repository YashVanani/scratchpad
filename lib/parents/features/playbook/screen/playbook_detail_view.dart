import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaybookDetailScreen extends StatefulWidget {
  @override
  _PlaybookDetailScreenState createState() => _PlaybookDetailScreenState();
}

class _PlaybookDetailScreenState extends State<PlaybookDetailScreen> {
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
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  'Different Perspectives in Literature',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              const Padding(
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
                            color: Color(0xff16B364),
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Easy",
                            style: TextStyle(color: Color(0xff16B364)),
                          ),
                        ],
                      )
                    ],
                  )),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Developmental stage:",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "6 - 7 - 8",
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
                          ...['SEL', 'Growth Mindset', 'Learning']
                              .take(2)
                              .map((e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 4),
                                  margin: const EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffEAECF0)),
                                  child: Text(
                                    e,
                                    style: const TextStyle(fontSize: 12),
                                  )))
                              .toList(),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 4),
                              margin: const EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffEAECF0)),
                              child: Text('+${[
                                    'SEL',
                                    'Growth Mindset',
                                    'Learning'
                                  ].length - 2}')),
                        ],
                      )
                    ],
                  )),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  'Exploring different perspectives in literature is a crucial aspect of enhancing students understanding of texts. This approach encourages critical thinking, empathy, and a broader understanding of the human experience. By examining stories from various viewpoints, students can gain insights into cultural, social, and historical contexts that shape characters motivations and actions.',
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
                        children: [
                          const PlayBookPDFCard(),
                          const PlayBookPDFCard(),
                          const PlayBookPDFCard(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const PlaybookTab(),
            ],
          ),
        ));
  }
}

class PlayBookPDFCard extends StatelessWidget {
  const PlayBookPDFCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("1. MATHS.pdf"),
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
  const PlaybookTab({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 24),
                child: SizedBox(
                    height: 300,
                    child: const TabBarView(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1. Step into Others' Shoes:",style: TextStyle(fontWeight: FontWeight.w500),),
                          Text("Imagine how characters from different backgrounds feel and think. This helps students understand and empathize with diverse experiences."),
                          Text("1. Step into Others' Shoes:",style: TextStyle(fontWeight: FontWeight.w500),),
                          Text("Imagine how characters from different backgrounds feel and think. This helps students understand and empathize with diverse experiences."),
                          Text("1. Step into Others' Shoes:",style: TextStyle(fontWeight: FontWeight.w500),),
                          Text("Imagine how characters from different backgrounds feel and think. This helps students understand and empathize with diverse experiences."),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1. Action Steps",style: TextStyle(fontWeight: FontWeight.w500),),
                          Text("Imagine how characters from different backgrounds feel and think. This helps students understand and empathize with diverse experiences."),
                          Text("1. Step into Others' Shoes:",style: TextStyle(fontWeight: FontWeight.w500),),
                          Text("Imagine how characters from different backgrounds feel and think. This helps students understand and empathize with diverse experiences."),
                          Text("1. Step into Others' Shoes:",style: TextStyle(fontWeight: FontWeight.w500),),
                          Text("Imagine how characters from different backgrounds feel and think. This helps students understand and empathize with diverse experiences."),
                        ],
                      ),])),
              )
            ])));
  }
}
