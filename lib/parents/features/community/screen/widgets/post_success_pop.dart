
import 'package:clarified_mobile/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostSuccessPop extends StatelessWidget {
  const PostSuccessPop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return AlertDialog(
          scrollable: true,
          iconPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.white,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: SvgPicture.asset('assets/svg/post.svg'),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '${AppLocalizations.of(context)!.thank_you_for_sharing_your_thoughts}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Color(0xff475467)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height:20,
              ),
              InkWell(
                  onTap: () {
                    context.pop();
                    GoRouter.of(context).pushReplacementNamed("parents-community");
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: greenTextColor, width: 1),
                        color: greenTextColor,
                      ),
                      child: Text(
                        "${AppLocalizations.of(context)!.ok}",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ))),
            ]),
          ),
        );
      },
    );
  }
}
