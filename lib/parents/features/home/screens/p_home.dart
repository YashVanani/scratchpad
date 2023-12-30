import 'package:clarified_mobile/consts/commonStyle.dart';
import 'package:clarified_mobile/consts/imageRes.dart';
import 'package:clarified_mobile/main.dart';
import 'package:clarified_mobile/parents/features/dashboard/screen/dashboard.dart';
import 'package:clarified_mobile/parents/features/home/widgets/faqPopUp.dart';
import 'package:clarified_mobile/parents/features/home/widgets/survey_card_parents.dart';
import 'package:clarified_mobile/parents/features/playbook/screen/widgets/playbook_card.dart';
import 'package:clarified_mobile/parents/features/widgets/p_bottombar.dart';
import 'package:clarified_mobile/parents/models/dashboard.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:clarified_mobile/parents/models/survey_parent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../consts/colors.dart';
import '../../../../services/app_pref.dart';

class ParentsHome extends ConsumerWidget {
  ParentsHome({super.key});

  List<String> languageName = ["English", "Hindi", "Marathi"];
  String selectedLanguage = 'English';
  String languageCode = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(parentProfileProvider);
    final children = ref.watch(userListProvider);
    final currentChild = ref.watch(myCurrentChild);
    final dashboard = ref.watch(reportDashboardProvider);
    // final childClassroom = ref.watch(childClassroomProvider);
    final favoriteActivity = ref.watch(favoriteActivityProvider);
    print("+++++++PROFILE ${profile}");
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                        offset: Offset(0.0, 2))
                  ]),
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
                                TextSpan(
                                    text:
                                        "${AppLocalizations.of(context)!.hello}\n",
                                    style: CommonStyle.lexendMediumStyle
                                        .copyWith(
                                            fontSize: 12,
                                            color: liteGreenColor)),
                                //TextSpan(text: "Mrs. Smita Gupta", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),

                                profile.when(
                                  data: (u) {
                                    return TextSpan(text: u.name);
                                  },
                                  error: (e, st) {
                                    return TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .error_loading_user);
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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return languageDialog(ref);
                              });
                        },
                        icon: const Icon(
                          Icons.translate_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ParentFAQPopUp(
                                  widgetRef: ref,
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.help_outline_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed("parents-notification");
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    color: secondTextColor,
                    thickness: 1.5,
                  ),
                  children.when(
                      data: (d) {
                        // final childClassroom = ref.watch(childClassroomProvider);
                        if (currentChild == null) {
                          //ref.read(myCurrentChild.notifier).state = (d[0] as UserInfo);
                        }
                        print(currentChild);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15, top: 5),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: purpleColor,
                                  backgroundImage:
                                      NetworkImage(currentChild?.profileUrl??"",),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(currentChild?.name ?? '',
                                          style: CommonStyle.lexendMediumStyle
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      FutureBuilder(
                                          future: getClassroom(
                                              currentChild?.currentClassId ??
                                                  '',
                                              ref),
                                          builder: ((context, snapshot) => Text(
                                              snapshot.data?.name ?? "",
                                              style: CommonStyle
                                                  .lexendMediumStyle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: greyTextColor)))),
                                    ]),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return childrenDialog(ref);
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                      AppLocalizations.of(context)!.change,
                                      style: CommonStyle.lexendMediumStyle
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: greenTextColor)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      error: (e, j) => SizedBox(),
                      loading: () => const SizedBox())
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16,
                      ),
                      child: SurveyCardParent(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.recent_report,
                              style: CommonStyle.lexendMediumStyle
                                  .copyWith(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 16),
                          InkWell(
                            onTap: () {
                              GoRouter.of(context).pushNamed("parents-report");
                            },
                            child: Text(AppLocalizations.of(context)!.view_all,
                                style: CommonStyle.lexendMediumStyle.copyWith(
                                    fontSize: 14, color: greenTextColor)),
                          )
                        ],
                      ),
                    ),
                    dashboard.when(
                        data: (d) => SizedBox(
                              height: MediaQuery.of(context).size.height * .20,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: d.length < 3 ? d.length : 3,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, right: index == 2 ? 20 : 0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .20,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8,
                                        decoration: ShapeDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment(0.00, -1.00),
                                            end: Alignment(0, 1),
                                            colors: d[index].type == 'social'
                                                ? [
                                                    Color(0xFF81F2BC),
                                                    Color(0xFF48B990),
                                                  ]
                                                : d[index].type == 'emotional'
                                                    ? [
                                                        Color(0xFFF28181),
                                                        Color(0xFFB94848),
                                                      ]
                                                    : d[index].type ==
                                                            'classroom-experience'
                                                        ? [
                                                            Color(0xFFDB71F1),
                                                            Color(0xFF4A651ED),
                                                          ]
                                                        : [
                                                            Color(0xFF81BBF2),
                                                            Color(0xFF4882B9),
                                                          ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16,
                                                    bottom: 0,
                                                    left: 16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        (d[index].title ?? '')
                                                            .replaceAll(
                                                                '-', ' ')
                                                            .toUpperCase(),
                                                        style: CommonStyle
                                                            .lexendMediumStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color:
                                                                    textMainColor)),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      d[index].desc ?? "",
                                                      maxLines: 2,
                                                      style: CommonStyle
                                                          .lexendMediumStyle
                                                          .copyWith(
                                                              fontSize: 12,
                                                              color:
                                                                  textMainColor),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: double.infinity,
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            ref
                                                                .read(playbookIdsState
                                                                    .notifier)
                                                                .state = d[
                                                                        index]
                                                                    .activities ??
                                                                [];
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            DashboardScreen(
                                                                              dashboardReport: d[index],
                                                                            )));
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 16),
                                                            child: Container(
                                                              decoration:
                                                                  ShapeDecoration(
                                                                color:
                                                                    yellowColor,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        8),
                                                                child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .view_result,
                                                                  style: CommonStyle
                                                                      .lexendMediumStyle
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              (d[index].imageUrl !=
                                                                          null &&
                                                                      (d[index]
                                                                              .imageUrl
                                                                              ?.isNotEmpty ??
                                                                          false))
                                                                  ? Image
                                                                      .network(
                                                                      d[index].imageUrl ??
                                                                          "",
                                                                      height:
                                                                          80,
                                                                    )
                                                                  : Image.asset(
                                                                      ImageRes
                                                                          .manImage,
                                                                      height:
                                                                          80)
                                                            ],
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
                        error: (e, j) => SizedBox(),
                        loading: () => SizedBox()),
                    const SizedBox(height: 20),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Text(AppLocalizations.of(context)!.school_corner,
                                style: CommonStyle.lexendMediumStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 150,
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
                                      onTap: () {
                                        GoRouter.of(context)
                                            .pushNamed("parents-playbook");
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox.square(
                                            child: Container(
                                                decoration: ShapeDecoration(
                                                  color: boxColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 7,
                                                      horizontal: 7),
                                                  child: Image.asset(
                                                    ImageRes.bookImage,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .playbook,
                                            style: CommonStyle.lexendMediumStyle
                                                .copyWith(fontSize: 14),
                                          ),
                                          const Align(
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
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 150,
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
                                      onTap: () {
                                        GoRouter.of(context)
                                            .pushNamed("parents-doubt");
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox.square(
                                            child: Container(
                                                decoration: ShapeDecoration(
                                                  color: orangeColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 7,
                                                      horizontal: 7),
                                                  child: Image.asset(
                                                    ImageRes.bookImage,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .post_lesson_doubt,
                                                  style: CommonStyle
                                                      .lexendMediumStyle
                                                      .copyWith(fontSize: 14),
                                                ),
                                              ),
                                              const Align(
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
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: blueColor,
                            border: Border.all(color: blueBorderColor),
                            borderRadius: BorderRadius.circular(8)),
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
                                      AppLocalizations.of(context)!.community,
                                      style: CommonStyle.lexendMediumStyle
                                          .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .interact_engage,
                                      style: CommonStyle.lexendMediumStyle
                                          .copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    InkWell(
                                      onTap: () {
                                        GoRouter.of(context)
                                            .pushNamed("parents-community");
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            color: darkBlueColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 12),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .open_community,
                                              style: CommonStyle
                                                  .lexendMediumStyle
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Favorite Activity",
                              style: CommonStyle.lexendMediumStyle
                                  .copyWith(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 16),
                          InkWell(
                            onTap: () {
                              GoRouter.of(context)
                                  .pushNamed("parents-favorite-activity");
                            },
                            child: Text(AppLocalizations.of(context)!.view_all,
                                style: CommonStyle.lexendMediumStyle.copyWith(
                                    fontSize: 14, color: greenTextColor)),
                          )
                        ],
                      ),
                    ),
                    favoriteActivity.when(
                        data: (d) {
                          return ListView.builder(
                              itemCount: d.length <= 3 ? d.length : 3,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (cnt, index) {
                                return PlayBookCard(playbook: d[index]);
                              });
                        },
                        error: (i, j) => Text(i.toString()),
                        loading: () => SizedBox())
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

  getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    languageCode = prefs.getString(AppPref.isLanguageCode) ?? 'en';
  }

  bottomsheet(context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildExpansionTile(1, context),
          ],
        ),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();

  _buildExpansionTile(int index, context) {
    final GlobalKey expansionTileKey = GlobalKey();
    double? previousOffset;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: expansionTileKey,
        onExpansionChanged: (isExpanded) {
          if (isExpanded) previousOffset = _scrollController.offset;
          _scrollToSelectedContent(
              isExpanded, previousOffset!, index, expansionTileKey);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.see_video,
                          style: CommonStyle.lexendMediumStyle
                              .copyWith(fontSize: 14, color: whiteColor),
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

  void _scrollToSelectedContent(
      bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      // make sure that your widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      _scrollController.animateTo(
          isExpanded ? (box.size.height * index) : previousOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear);
    }
  }

  childrenDialog(WidgetRef ref) {
    final children = ref.watch(userListProvider);
    final currentChild = ref.watch(myCurrentChild);
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: whiteColor,
        content: Column(
          children: [
            Container(
              height: 240,
              width: 500,
              child: children.when(
                  data: (d) {
                    return ListView.builder(
                        itemCount: d.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: secondTextColor,
                                  border: Border.all(color: whiteTextColor),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                   CircleAvatar(
                                     radius: 22,
                                     backgroundColor: purpleColor,
                                     backgroundImage:
                                         NetworkImage(d[index]?.profileUrl??"",),
                                   ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(d[index].name,
                                              style: CommonStyle
                                                  .lexendMediumStyle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          FutureBuilder(
                                              future: getClassroom(
                                                  d[index].currentClassId, ref),
                                              builder: ((context, snapshot) => Text(
                                                  snapshot.data?.name ?? "",
                                                  style: CommonStyle
                                                      .lexendMediumStyle
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color:
                                                              greyTextColor)))),
                                        ],
                                      ),
                                    ),
                                    Radio(
                                      value: ref
                                              .read(myCurrentChild.notifier)
                                              .state
                                              ?.id ==
                                          d[index].id,
                                      groupValue: true,
                                      onChanged: (value) {
                                        setState(() {
                                          ref
                                              .read(myCurrentChild.notifier)
                                              .state = d[index];

                                          ref.refresh(childClassroomProvider);
                                          Navigator.pop(context);
                                          // _site = value;
                                        });
                                        ref.refresh(surveyInboxParentProvider);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  error: (e, j) =>
                      Text(AppLocalizations.of(context)!.something_went_wrong),
                  loading: () => const SizedBox()),
            ),
          ],
        ),
      );
    });
  }

  languageDialog(WidgetRef ref) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Colors.white,
        content: Column(
          children: [
            Container(
              height: 240,
              width: 500,
              child: ListView.builder(
                itemCount: languageName.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: InkWell(
                      onTap: () async {
                        selectedLanguage =
                            languageName[index]; // Update the selected language
                        if (selectedLanguage == "English") {
                          languageCode = 'en';
                          ClarifiedApp.setLocal(context, const Locale('en'));

                          await AppPref.setLanguageCode('en');
                        } else if (selectedLanguage == "Hindi") {
                          languageCode = 'hi';
                          ClarifiedApp.setLocal(context, const Locale('hi'));
                          await AppPref.setLanguageCode('hi');
                        } else {
                          languageCode = 'mr';
                          ClarifiedApp.setLocal(context, const Locale('mr'));
                          await AppPref.setLanguageCode('mr');
                        }
                        ref.read(selectedLanguageProvider.notifier).state =
                            selectedLanguage;
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  languageName[index],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Radio(
                                value: languageName[index],
                                groupValue: ref
                                    .read(selectedLanguageProvider.notifier)
                                    .state,
                                onChanged: (value) async {
                                  selectedLanguage = value.toString();

                                  if (selectedLanguage == "English") {
                                    languageCode = 'en';
                                    ClarifiedApp.setLocal(
                                        context, const Locale('en'));
                                    await AppPref.setLanguageCode('en');
                                  } else if (selectedLanguage == "Hindi") {
                                    languageCode = 'hi';
                                    ClarifiedApp.setLocal(
                                        context, const Locale('hi'));
                                    await AppPref.setLanguageCode('hi');
                                  } else {
                                    languageCode = 'mr';
                                    ClarifiedApp.setLocal(
                                        context, const Locale('mr'));
                                    await AppPref.setLanguageCode('mr');
                                  }
                                  ref
                                      .read(selectedLanguageProvider.notifier)
                                      .state = selectedLanguage;
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
