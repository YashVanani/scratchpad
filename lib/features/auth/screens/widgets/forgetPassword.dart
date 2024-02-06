import 'package:clarified_mobile/consts/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';
class ForgetPasswordPop extends StatelessWidget {
   ForgetPasswordPop({
    super.key,
  });
  TextEditingController email = TextEditingController();

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
                child: Image.asset('assets/keyDark.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${AppLocalizations.of(context)!.forget_password.replaceAll("?","")}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (e) => e?.isNotEmpty == true
                              ? null
                              : AppLocalizations.of(context)!.please_provide_id,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                            hintText: "Eg: student@gmail.com",
                            prefixIcon: const Icon(
                              Icons.account_circle_outlined,
                            ),
                            // icon: const Icon(Icons.email),
                          ),
                        ),
                       
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () async {
                    //  SharedPreferences prefs = await SharedPreferences.getInstance();
                    //  prefs.setBool('communityPopShown', true);
                    if(email.text.isNotEmpty){
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                    var snackBar = SnackBar(content: Text("Mail send"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    context.pop();
                    }
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
                        "${AppLocalizations.of(context)!.ok_send_email}",
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
