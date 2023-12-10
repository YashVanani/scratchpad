import 'package:clarified_mobile/consts/commonStyle.dart';
import 'package:clarified_mobile/consts/imageRes.dart';
import 'package:clarified_mobile/features/home/widgets/survey_card.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:clarified_mobile/parents/features/home/widgets/survey_card_parents.dart';
import 'package:clarified_mobile/parents/features/widgets/p_bottombar.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../consts/colors.dart';

// class ParentsHome extends ConsumerWidget {
//   const ParentsHome({super.key});

//   @override
//   State<ParentsHome> createState() => _ParentsHomeState();
// }

// class _ParentsHomeState extends State<ParentsHome> {
  
//   @override
//   Widget build(BuildContext context) {
//     final profile = ref.watch(profileProvider);
//     print("+++++++PROFILE ${profile.data?.value?.name}");
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                   color: whiteColor,
//                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
//                   boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 2))]),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 15),
//                           child: Text.rich(
//                             TextSpan(
//                               children: [
//                                 TextSpan(text: "Good Morning!\n", style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 12, color: liteGreenColor)),
//                                 TextSpan(text: "Mrs. Smita Gupta", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
//                                 // profile.when(
//                                 //   data: (u) => TextSpan(text: u.name),
//                                 //   error: (e, st) {
//                                 //     return const TextSpan(text: "Error Loading User");
//                                 //   },
//                                 //   loading: () => const TextSpan(text: "---"),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         padding: EdgeInsets.zero,
//                         onPressed: () {
//                           GoRouter.of(context).pushNamed("parents-report");
//                         },
//                         icon: const Icon(
//                           Icons.translate_outlined,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => print('outline'),
//                         icon: const Icon(
//                           Icons.help_outline_outlined,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                          GoRouter.of(context).pushNamed("parents-notification");
//                         },
//                         icon: const Icon(
//                           Icons.notifications_outlined,
//                         ),
//                       )
//                     ],
//                   ),
//                   Divider(
//                     color: secondTextColor,
//                     thickness: 1.5,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 15, top: 5),
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 15),
//                           child: CircleAvatar(
//                             radius: 30,
//                             backgroundColor: purpleColor,
//                             backgroundImage: AssetImage(ImageRes.profileImage),
//                           ),
//                         ),
//                         SizedBox(width: 15),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Arjun Gupta", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold)),
//                               Text("Class VII B", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: greyTextColor)),
//                             ],
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return childrenDialog();
//                                 });
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 15),
//                             child: Text("Change",
//                                 style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: greenTextColor)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Container(
//                         height: 112,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 16,
//                         ),
//                         decoration: ShapeDecoration(
//                           color: const Color(0xFFFEE4E2),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           shadows: const [
//                             BoxShadow(
//                               color: Color(0x0C101828),
//                               blurRadius: 2,
//                               offset: Offset(0, 1),
//                               spreadRadius: 0,
//                             )
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SvgPicture.asset(
//                               "assets/svg/no_survey.svg",
//                               width: 80,
//                               height: 80,
//                             ),
//                             const SizedBox(width: 14),
//                             Expanded(
//                               child: SizedBox(
//                                 // height: 51,
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'No survey available',
//                                       style: CommonStyle.lexendMediumStyle.copyWith(
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       // mainAxisSize: MainAxisSize.min,
//                                       // mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset("assets/svg/clock.svg"),
//                                         const SizedBox(width: 8),
//                                         Expanded(
//                                           child:
//                                               Text('Next Survey Starts : 07/11/2023', style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 12, color: darkGreenColor)),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Container(
//                         height: 170,
//                         decoration: ShapeDecoration(
//                           gradient: const LinearGradient(
//                             begin: Alignment(0.00, -1.00),
//                             end: Alignment(0, 1),
//                             colors: [
//                               Color(0xFFF28181),
//                               Color(0xFFB84848),
//                             ],
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           mainAxisSize: MainAxisSize.max,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Expanded(
//                               flex: 7,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Quest for Choices!",
//                                         style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 20, color: secondTextColor)),
//                                     Text(
//                                       "Let's Explore How We Decide",
//                                       overflow: TextOverflow.ellipsis,
//                                       style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 12, color: whiteTextColor),
//                                     ),
//                                     Expanded(
//                                       child: Container(
//                                         height: double.infinity,
//                                       ),
//                                     ),
//                                     Container(
//                                       decoration: ShapeDecoration(
//                                         color: yellowColor,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                                         child: Text(
//                                           'Start Now',
//                                           style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   SvgPicture.asset(
//                                     "assets/svg/survey_insight.svg",
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('Recent Reports', style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.w500)),
//                           SizedBox(width: 16),
//                           Text('View all', style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14, color: greenTextColor)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * .18,
//                       child: ListView.builder(
//                           shrinkWrap: true,
//                           scrollDirection: Axis.horizontal,
//                           itemCount: 3,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: EdgeInsets.only(left: 15, right: index == 2 ? 20 : 0),
//                               child: Container(
//                                 height: MediaQuery.of(context).size.height * .18,
//                                 width: MediaQuery.of(context).size.width * .8,
//                                 decoration: ShapeDecoration(
//                                   gradient: const LinearGradient(
//                                     begin: Alignment(0.00, -1.00),
//                                     end: Alignment(0, 1),
//                                     colors: [
//                                       Color(0xFF81F2BC),
//                                       Color(0xFF48B990),
//                                     ],
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   mainAxisSize: MainAxisSize.max,
//                                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                                   children: [
//                                     Expanded(
//                                       flex: 7,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(top: 16, bottom: 0, left: 16),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.max,
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text("Social Awareness",
//                                                 style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 16, color: textMainColor)),
//                                             SizedBox(height: 5),
//                                             Text(
//                                               "16-Oct-2023",
//                                               style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 12, color: textMainColor),
//                                             ),
//                                             Expanded(
//                                               child: Container(
//                                                 height: double.infinity,
//                                               ),
//                                             ),
//                                             Row(
//                                               crossAxisAlignment: CrossAxisAlignment.end,
//                                               children: [
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(bottom: 16),
//                                                   child: Container(
//                                                     decoration: ShapeDecoration(
//                                                       color: yellowColor,
//                                                       shape: RoundedRectangleBorder(
//                                                         borderRadius: BorderRadius.circular(10),
//                                                       ),
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                                                       child: Text(
//                                                         'View Result',
//                                                         style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Column(
//                                                     mainAxisAlignment: MainAxisAlignment.end,
//                                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                                     children: [Image.asset(ImageRes.manImage, height: 80)],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }),
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       color: Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 15),
//                             Text("School Corner", style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
//                             SizedBox(height: 15),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: Container(
//                                     clipBehavior: Clip.antiAlias,
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 20,
//                                     ),
//                                     decoration: ShapeDecoration(
//                                       color: skyeWhiteColor,
//                                       shape: RoundedRectangleBorder(
//                                         side: const BorderSide(
//                                           width: 1,
//                                           color: skyeColor,
//                                         ),
//                                         borderRadius: BorderRadius.circular(24),
//                                       ),
//                                       shadows: const [
//                                         BoxShadow(
//                                           color: skyeColor,
//                                           blurRadius: 0,
//                                           offset: Offset(0, 3),
//                                           spreadRadius: 0,
//                                         )
//                                       ],
//                                     ),
//                                     child: InkWell(
//                                       onTap: () {},
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox.square(
//                                             child: Container(
//                                                 decoration: ShapeDecoration(
//                                                   color: boxColor,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(13),
//                                                   ),
//                                                 ),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
//                                                   child: Image.asset(
//                                                     ImageRes.bookImage,
//                                                     height: 25,
//                                                     width: 25,
//                                                   ),
//                                                 )),
//                                           ),
//                                           SizedBox(height: 15),
//                                           Text(
//                                             "Playbook",
//                                             style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14),
//                                           ),
//                                           Align(
//                                               alignment: Alignment.topRight,
//                                               child: Icon(
//                                                 Icons.arrow_forward,
//                                                 color: boxColor,
//                                                 size: 22,
//                                               ))
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 15),
//                                 Expanded(
//                                   flex: 1,
//                                   child: Container(
//                                     clipBehavior: Clip.antiAlias,
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 20,
//                                     ),
//                                     decoration: ShapeDecoration(
//                                       color: boxOrangeColor,
//                                       shape: RoundedRectangleBorder(
//                                         side: const BorderSide(
//                                           width: 1,
//                                           color: orangeBorderColor,
//                                         ),
//                                         borderRadius: BorderRadius.circular(24),
//                                       ),
//                                       shadows: const [
//                                         BoxShadow(
//                                           color: orangeBorderColor,
//                                           blurRadius: 0,
//                                           offset: Offset(0, 3),
//                                           spreadRadius: 0,
//                                         )
//                                       ],
//                                     ),
//                                     child: InkWell(
//                                       onTap: () {},
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox.square(
//                                             child: Container(
//                                                 decoration: ShapeDecoration(
//                                                   color: orangeColor,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(13),
//                                                   ),
//                                                 ),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
//                                                   child: Image.asset(
//                                                     ImageRes.bookImage,
//                                                     height: 25,
//                                                     width: 25,
//                                                   ),
//                                                 )),
//                                           ),
//                                           SizedBox(height: 15),
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Text(
//                                                   "Post lesson Doubt",
//                                                   style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14),
//                                                 ),
//                                               ),
//                                               Align(
//                                                   alignment: Alignment.topRight,
//                                                   child: Icon(
//                                                     Icons.arrow_forward,
//                                                     color: orangeColor,
//                                                     size: 22,
//                                                   ))
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 20),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Container(
//                         decoration: BoxDecoration(color: blueColor, border: Border.all(color: blueBorderColor), borderRadius: BorderRadius.circular(8)),
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 12, right: 10),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 15),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Community",
//                                       style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
//                                     ),
//                                     SizedBox(height: 15),
//                                     Text(
//                                       "Interact Engage and Share",
//                                       style: CommonStyle.lexendMediumStyle.copyWith(
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                     SizedBox(height: 15),
//                                     InkWell(
//                                       onTap: (){
//                                         GoRouter.of(context).pushNamed("parents-community");
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(bottom: 16),
//                                         child: Container(
//                                           decoration: ShapeDecoration(
//                                             color: darkBlueColor,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//                                             child: Text(
//                                               'Open community',
//                                               style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               Expanded(
//                                   flex: 2,
//                                   child: Image.asset(
//                                     ImageRes.groupUserImage,
//                                     fit: BoxFit.fill,
//                                   ))
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const ParentsBottomBar(
//         selected: 'parents-home',
//       ),
//     );
//   }

//   }

class ParentsHome extends ConsumerWidget{
  ParentsHome({super.key});

@override
  Widget build(BuildContext context, WidgetRef ref) {
       final profile = ref.watch(parentProfileProvider);
    print("+++++++PROFILE ${profile}");
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 2))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "Hello\n", style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 12, color: liteGreenColor)),
                                //TextSpan(text: "Mrs. Smita Gupta", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
                                profile.when(
                                  data: (u) => TextSpan(text: u.name),
                                  error: (e, st) {
                                    return const TextSpan(text: "Error Loading User");
                                  },
                                  loading: () => const TextSpan(text: "---"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          GoRouter.of(context).pushNamed("parents-report");
                        },
                        icon: const Icon(
                          Icons.translate_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed("parents-doubt");
                        },
                        icon: const Icon(
                          Icons.help_outline_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                         GoRouter.of(context).pushNamed("parents-notification");
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: secondTextColor,
                    thickness: 1.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: purpleColor,
                            backgroundImage: AssetImage(ImageRes.profileImage),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Arjun Gupta", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold)),
                              Text("Class VII B", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: greyTextColor)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return childrenDialog();
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text("Change",
                                style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: greenTextColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16,
            ),
            child: SurveyCardParent(),
          ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Recent Reports', style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.w500)),
                          SizedBox(width: 16),
                          Text('View all', style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14, color: greenTextColor)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .18,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(left: 15, right: index == 2 ? 20 : 0),
                              child: Container(
                                height: MediaQuery.of(context).size.height * .18,
                                width: MediaQuery.of(context).size.width * .8,
                                decoration: ShapeDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.00, -1.00),
                                    end: Alignment(0, 1),
                                    colors: [
                                      Color(0xFF81F2BC),
                                      Color(0xFF48B990),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 16, bottom: 0, left: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Social Awareness",
                                                style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 16, color: textMainColor)),
                                            SizedBox(height: 5),
                                            Text(
                                              "16-Oct-2023",
                                              style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 12, color: textMainColor),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: double.infinity,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 16),
                                                  child: Container(
                                                    decoration: ShapeDecoration(
                                                      color: yellowColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                      child: Text(
                                                        'View Result',
                                                        style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [Image.asset(ImageRes.manImage, height: 80)],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 20),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Text("School Corner", style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                    decoration: ShapeDecoration(
                                      color: skyeWhiteColor,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 1,
                                          color: skyeColor,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: skyeColor,
                                          blurRadius: 0,
                                          offset: Offset(0, 3),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox.square(
                                            child: Container(
                                                decoration: ShapeDecoration(
                                                  color: boxColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(13),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                                                  child: Image.asset(
                                                    ImageRes.bookImage,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                )),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "Playbook",
                                            style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14),
                                          ),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: boxColor,
                                                size: 22,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                    decoration: ShapeDecoration(
                                      color: boxOrangeColor,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 1,
                                          color: orangeBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: orangeBorderColor,
                                          blurRadius: 0,
                                          offset: Offset(0, 3),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox.square(
                                            child: Container(
                                                decoration: ShapeDecoration(
                                                  color: orangeColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(13),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                                                  child: Image.asset(
                                                    ImageRes.bookImage,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                )),
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Post lesson Doubt",
                                                  style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14),
                                                ),
                                              ),
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: Icon(
                                                    Icons.arrow_forward,
                                                    color: orangeColor,
                                                    size: 22,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(color: blueColor, border: Border.all(color: blueBorderColor), borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, right: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Community",
                                      style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "Interact Engage and Share",
                                      style: CommonStyle.lexendMediumStyle.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    InkWell(
                                      onTap: (){
                                        GoRouter.of(context).pushNamed("parents-community");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            color: darkBlueColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                                            child: Text(
                                              'Open community',
                                              style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                  flex: 2,
                                  child: Image.asset(
                                    ImageRes.groupUserImage,
                                    fit: BoxFit.fill,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ParentsBottomBar(
        selected: 'parents-home',
      ),
    );
  
  }
  bottomsheet(context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildExpansionTile(1,context),
          ],
        ),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();

  _buildExpansionTile(int index,context) {
    final GlobalKey expansionTileKey = GlobalKey();
    double? previousOffset;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: expansionTileKey,

        onExpansionChanged: (isExpanded) {
          if (isExpanded) previousOffset = _scrollController.offset;
          _scrollToSelectedContent(isExpanded, previousOffset!, index, expansionTileKey);
        },
        title: Text('My expansion tile $index'),
        children: _buildExpansionTileChildren(context),
      ),
    );
  }

  List<Widget> _buildExpansionTileChildren(context) => [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            child: Column(
              children: [
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vulputate arcu interdum lacus pulvinar aliquam.',
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: ShapeDecoration(
                      color: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Center(
                        child: Text(
                          'See Video',
                          style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14, color: whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ];

  void _scrollToSelectedContent(bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      // make sure that your widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      _scrollController.animateTo(isExpanded ? (box.size.height * index) : previousOffset, duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

  childrenDialog() {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: whiteColor,
        content: Column(
          children: [
            Container(
              height: 240,
              width: 500,
              child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(color: secondTextColor, border: Border.all(color: whiteTextColor), borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: purpleColor,
                                backgroundImage: AssetImage(ImageRes.profileImage),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Arjun Gupta", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold)),
                                    Text("Class VII B", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: greyTextColor)),
                                  ],
                                ),
                              ),
                              Radio(
                                value: true,
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    // _site = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }


}