import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/features/subjects/model/quiz_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clarified_mobile/features/shared/widgets/app_buttombar.dart';
import 'package:clarified_mobile/features/shared/widgets/profile_photo_widget.dart';
import 'package:clarified_mobile/model/user.dart';

class StudentProfile extends ConsumerWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final quizAttempted = ref.watch(quizAttemptProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pushNamed("profile-passwd"),
            child: const Text("Change Password"),
          )
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          child: profile.when(
            data: (data) {
              return Column(
                children: [
                  InkWell(
                    onTap: () =>
                        GoRouter.of(context).pushNamed("profile-avatar"),
                    child: SizedBox(
                      width: 90,
                      height: 90,
                      child: Stack(
                        children: [
                         
                          SizedBox(
                            width: 90,
                      height: 90,
                            child: ProfilePhotoWidget(
                                                    photoUrl: data.profileUrl,
                                                    gender: data.gender,
                                                  ),
                          ),
                           Positioned(top:0,right: 0,child: Icon(Icons.edit,color: greenTextColor,size: 28,)),
                        ],
                      )
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    data.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF1D2939),
                      fontSize: 24,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      data.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF1D2939),
                        fontSize: 18,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: ShapeDecoration(
                          color: const Color(0xFF16B264),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "EARNED XP ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 7.0,
                                right: 2.0,
                              ),
                              child: SvgPicture.asset(
                                "assets/svg/crown.svg",
                                width: 16,
                                height: 16,
                                theme: const SvgTheme(
                                  currentColor: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "${data.balance.total}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        border: Border(
                          left: BorderSide(color: Color(0xFFF2F4F7)),
                          top: BorderSide(width: 1, color: Color(0xFFF2F4F7)),
                          right: BorderSide(color: Color(0xFFF2F4F7)),
                          bottom: BorderSide(color: Color(0xFFF2F4F7)),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/compass.png'),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'ClarifiED Stats',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF344054),
                                  fontSize: 22,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: quizAttempted.asData?.value.length==0?MainAxisAlignment.center: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 16,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFEF3F2),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFF04437),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'TOTAL SPENT XP',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFFD92C20),
                                              fontSize: 12,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w500,
                                              height: 0.12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(),
                                          child: SvgPicture.asset(
                                            "assets/svg/crown.svg",
                                            width: 24,
                                            height: 24,
                                            theme: const SvgTheme(
                                              currentColor: Color(0xFFD92C20),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${data.balance.spent}",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            color: Color(0xFFD92C20),
                                            fontSize: 16,
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w600,
                                            height: 0.09,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                               quizAttempted.when(data: (d){
                                      if(d!=0){
                                        return    Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 16,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFEDFCF2),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFF16B264),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'QUIZ ATTEMPED',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF16B264),
                                              fontSize: 12,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w500,
                                              height: 0.12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(),
                                          child: SvgPicture.asset(
                                            "assets/svg/crown.svg",
                                            width: 24,
                                            height: 24,
                                            theme: const SvgTheme(
                                              currentColor: Color(0xFF16B264),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                         Text(
                                          d.length.toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF09914F),
                                            fontSize: 16,
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w600,
                                            height: 0.09,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                           
                                      }
                                      return SizedBox();
                                    }, error: (e,j)=>SizedBox(), loading: ()=>SizedBox())
                                  
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Expanded(child: SizedBox()),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: InkWell(
                          //     onTap: () => print("Setting"),
                          //     child: Container(
                          //       padding: const EdgeInsets.symmetric(
                          //         horizontal: 16,
                          //         vertical: 14,
                          //       ),
                          //       decoration: ShapeDecoration(
                          //         color: const Color(0xFFFCFCFD),
                          //         shape: RoundedRectangleBorder(
                          //           side: const BorderSide(
                          //             width: 1,
                          //             color: Color(0xFFEAECF0),
                          //           ),
                          //           borderRadius: BorderRadius.circular(16),
                          //         ),
                          //         shadows: const [
                          //           BoxShadow(
                          //             color: Color(0xFFEAECF0),
                          //             blurRadius: 0,
                          //             offset: Offset(0, 3),
                          //             spreadRadius: 0,
                          //           )
                          //         ],
                          //       ),
                          //       child: const SizedBox(
                          //         height: 20,
                          //         child: Row(
                          //           mainAxisSize: MainAxisSize.min,
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.center,
                          //           children: [
                          //             Text(
                          //               'Profile Setting',
                          //               textAlign: TextAlign.center,
                          //               style: TextStyle(
                          //                 color: Color(0xFF344054),
                          //                 fontSize: 14,
                          //                 fontFamily: 'Lexend',
                          //                 fontWeight: FontWeight.w400,
                          //                 height: 0.10,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: const Text("Logout!"),
                                        content: const Text("Are you sure?"),
                                        actions: [
                                          TextButton.icon(
                                            onPressed: () =>
                                                Navigator.of(ctx).maybePop(),
                                            icon: const Icon(Icons.stop_circle),
                                            label: const Text("No"),
                                          ),
                                          TextButton.icon(
                                            onPressed: () {
                                              Navigator.of(ctx).maybePop();
                                              FirebaseAuth.instance.signOut();
                                            },
                                            icon: const Icon(Icons.check),
                                            label: const Text("Yes"),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFCFCFD),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFFDB022),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0xFFFDB022),
                                      blurRadius: 0,
                                      offset: Offset(0, 1),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: const Text(
                                  'Log Out',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFDC6803),
                                    fontSize: 14,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
            error: (err, st) {
              print([err, st]);

              return const Center(
                child: Text("Error Loading Profile"),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppNavBar(
        selected: 'profile',
      ),
    );
  }
}
