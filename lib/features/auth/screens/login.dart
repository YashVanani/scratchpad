import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/features/auth/screens/widgets/forgetPassword.dart';
import 'package:clarified_mobile/model/school.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/services/notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLoading = false;
  bool remember_me = true;
  
  final NotificationService _notificationService = NotificationService();

  void attemptLogin() async {
    final schoolId = ref.read(schoolIdProvider);
    print("attempting school $schoolId");
    
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:
            "${loginIdController.text}@$schoolId.clarified-school.scratchpad.com",
        password: passwordController.text,
      );
      setState(() {
      isLoading = false;
    });
      if (FirebaseAuth.instance.currentUser?.uid.split('@')[0].split(':').last.toLowerCase() == 'parent') {
        _notificationService.updateTokenOnLogin('parent',ref);
        ref.read(myCurrentChild.notifier).state=null;
        ref.refresh(userListProvider);
        GoRouter.of(context).goNamed("parents-home");
      }
      if (FirebaseAuth.instance.currentUser?.uid.split('@')[0].split(':').last.toLowerCase() == 'student') {
          _notificationService.updateTokenOnLogin('student',ref);
        GoRouter.of(context).goNamed("home");
      }
       if (FirebaseAuth.instance.currentUser?.uid.split('@')[0].split(':').last.toLowerCase() == 'teacher') {
          _notificationService.updateTokenOnLogin('teacher',ref);
        GoRouter.of(context).goNamed("teachers-home");
      }
      GoRouter.of(context).goNamed("parents-home");
    } catch (e) {
      print(e);
      var snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
      isLoading = false;
    });
    }
  }

  @override
  void initState() {
    getInit();
    // TODO: implement initState
    super.initState();
  }

  getInit()async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
    //  prefs.clear();
     loginIdController.text= prefs.getString('email')??"";
      passwordController.text = prefs.getString('password')??"";
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppLocalizations.of(context)!.student_id,
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppLocalizations.of(context)!.password,
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
                              e?.isNotEmpty == true ? null : AppLocalizations.of(context)!.please_password,
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
                        SizedBox(
                          height: 5,
                        ),
                        Row(children: [
                          Checkbox(value: remember_me, onChanged: (v){
                           setState(() {
                              remember_me = v??false;
                           });
                          }),
                          Text(AppLocalizations.of(context)!.remember_me),
                          Spacer(),
                          InkWell(onTap: (){
                              showDialog(
            context: context,
            builder: (context) {
              return  ForgetPasswordPop();
            });
                          },child: Text(AppLocalizations.of(context)!.forget_password,style: TextStyle(color: Colors.red),))
                        ],),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  if (loginFormKey.currentState?.validate() ==
                                      true) {
                                    attemptLogin();
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                            
                                    if(remember_me==true){
                                      prefs.setString('email', loginIdController.text);
                              prefs.setString('password', passwordController.text);
                                    }else{
        prefs.setString('email', "");
                              prefs.setString('password', "");
                            
                                    }
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
                                      child: 
                                      isLoading?SizedBox(width: 10,height: 10,child: CircularProgressIndicator(color: whiteColor,)):
                                      Text(
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
