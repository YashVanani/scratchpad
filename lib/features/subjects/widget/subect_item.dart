import 'package:clarified_mobile/model/clazz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final Map<String, ({Color bg, Color shadow, Color border})> subjectThemeList = {
  "bluedark": (
    bg: const Color(0xFFD1E0FF),
    shadow: const Color(0xFFFEE4E2),
    border: const Color(0xFF2970FF),
  ),
  "red": (
    bg: const Color(0xFFFFFBFA),
    shadow: const Color(0xFFFEE4E2),
    border: const Color(0xFFFEE4E2),
  )
};

class SubjectItem extends StatelessWidget {
  final Subject subject;

  const SubjectItem({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = subjectThemeList['red']!;

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 15,
      ),
      decoration: ShapeDecoration(
        color: theme.bg,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: theme.shadow,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: [
          BoxShadow(
            color: theme.border,
            blurRadius: 0,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).pushNamed(
            "subject-detail",
            pathParameters: {
              "subjectId": subject.id,
            },
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            subject.iconImage.isNotEmpty?SizedBox.square(
              child: Container(
             
                decoration: ShapeDecoration(
                  color: theme.border,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:Image.network(subject.iconImage,width: 72,height: 72,),
                // child: SvgPicture.asset(
                //   "assets/svg/subjects/science.svg",
                //      height: 25,
                // width: 25,
                //   fit: BoxFit.contain,
                // ),
              ),
            ):SizedBox.square(
              child: Container(
             
                decoration: ShapeDecoration(
                  color: theme.border,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // child:Image.network(subject.iconImage),
                child: SvgPicture.asset(
                  "assets/svg/subjects/science.svg",
                     height: 72,
                width: 72,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              subject.name
                  
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1D2939),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
