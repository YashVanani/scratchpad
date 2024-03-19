import 'package:clarified_mobile/consts/imageRes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeacherAssistanceCards extends StatefulWidget {
  const TeacherAssistanceCards({super.key});

  @override
  State<TeacherAssistanceCards> createState() => _TeacherAssistanceCardsState();
}

class _TeacherAssistanceCardsState extends State<TeacherAssistanceCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.symmetric(horizontal:20),
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFFEAECF0)),
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x0C101828),
                blurRadius: 2,
                offset: Offset(0, 1),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Teaching Assistant',
                style: TextStyle(
                  color: Color(0xFF1D2939),
                  fontSize: 14,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: SvgPicture.asset(ImageRes.markLession),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 153,
                              child: Text(
                                'Mark a Lesson',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF344054),
                                  fontSize: 12,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                                  child: SvgPicture.asset(ImageRes.createLession),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Create Lesson Plan',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF344054),
                                  fontSize: 12,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}