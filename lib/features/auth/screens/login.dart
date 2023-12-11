import 'package:clarified_mobile/model/school.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final loginIdController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool isBusy = false;

  void attemptLogin() async {
    final schoolId = ref.read(schoolIdProvider);
    print("attempting school $schoolId");

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:
            "${loginIdController.text}@$schoolId.clarified-school.scratchpad.com",
        password: passwordController.text,
      );
      if (loginIdController.text.split('')[0].toUpperCase() == 'P') {
        GoRouter.of(context).goNamed("parents-home");
      }
      if (loginIdController.text.split('')[0].toUpperCase() == 'S') {
        GoRouter.of(context).goNamed("home");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 40,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset('assets/logo.png'),
                ),
              ),
            ),
            Expanded(
              flex: 60,
              child: Container(
                color: const Color(0xFFEAECF0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Student ID',
                            style: TextStyle(
                              color: Color(0xFF344054),
                              fontSize: 16,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: loginIdController,
                          keyboardType: TextInputType.text,
                          validator: (e) => e?.isNotEmpty == true
                              ? null
                              : "Please provide ID",
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
                            hintText: "eg: AS39983743",
                            prefixIcon: const Icon(
                              Icons.account_circle_outlined,
                            ),
                            // icon: const Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Password',
                            style: TextStyle(
                              color: Color(0xFF344054),
                              fontSize: 16,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          validator: (e) =>
                              e?.isNotEmpty == true ? null : "Please Password",
                          obscureText: !showPassword,
                          obscuringCharacter: '*',
                          autocorrect: false,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.key),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                            hintText: "eg: *****",
                            suffixIcon: IconButton(
                              // padding: const EdgeInsets.all(1),
                              onPressed: () => setState(
                                () => showPassword = !showPassword,
                              ),
                              icon: const Icon(Icons.visibility),
                              selectedIcon: const Icon(Icons.visibility_off),
                              isSelected: showPassword,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  if (loginFormKey.currentState?.validate() ==
                                      true) {
                                    attemptLogin();
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF04686E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x0C101828),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        // 'LOGIN',
                                        AppLocalizations.of(context)!.login,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w400,
                                          height: 0.09,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
