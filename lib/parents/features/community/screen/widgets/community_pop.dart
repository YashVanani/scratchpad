import 'package:clarified_mobile/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CommunityPop extends StatelessWidget {
  const CommunityPop({
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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: SvgPicture.asset('assets/svg/community.svg'),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Community Rules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text("""
1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.
2. tempor incididunt ut labore et dolore magna aliqua.
3. Ut enim ad minim veniamLorem ipsum dolor sit amet,
4. consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam
"""),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    context.pop();
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
                        "OK, GOT IT.",
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
