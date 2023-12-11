import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/parents/features/doubt/screen/doubt_detail_screen.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class DoubtScreen extends ConsumerWidget {
  const DoubtScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(childSubjectListProvider);
    final childClassroom = ref.watch(childClassroomProvider);
    final currentChild = ref.watch(myCurrentChild);
    return Scaffold(
        appBar: AppBar(
          title: Text('All Subjects'),
          actions: [
            FutureBuilder(
              future: getClassroom(currentChild?.currentClassId ?? '', ref),
              builder: ((context, snapshot) => Text(
                    snapshot.data?.name ?? "",
                    style: TextStyle(color: Color(0xffEF6820)),
                  )),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: childClassroom.when(
            data: (d) => ListView.builder(
                  itemCount: d.subjects.length,
                  itemBuilder: (c, i) {
                    print(d.subjects[i].teacherId);
                    print("++TEACHER ID++");
                    return SubjectCard(
                      subjectTeacherId: d.subjects[i].teacherId ?? "",
                      subjectId: d.subjects[i].subjectId,
                      classSubject: d.subjects[i],
                    );
                  },
                ),
            error: (e, j) => Text("Something went wrong"),
            loading: () => SizedBox()));
  }
}

class SubjectCard extends ConsumerWidget {
  const SubjectCard({
    super.key,
    required this.subjectTeacherId,
    required this.subjectId,
    required this.classSubject,
  });
  final String subjectId;
  final String subjectTeacherId;
  final ClassSubject classSubject;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: getSubjectInfo(subjectId, ref),
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              // GoRouter.of(context).pushNamed('parents-doubt-details');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => DoubtDetailScreen(
                            subject: snapshot.data!,
                            teacherId: subjectTeacherId,
                            classSubject: classSubject,
                          )));
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                children: [
                  snapshot.data?.bannerImage.isNotEmpty ?? false
                      ? Image.network(
                          snapshot.data?.bannerImage ?? "",
                          height: 30,
                          width: 30,
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data?.name ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Text(
                        "${snapshot.data?.topics.length} Chapters",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      )
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                    size: 14,
                  )
                ],
              ),
            ),
          );
        });
  }
}
