import 'package:cached_network_image/cached_network_image.dart';
import 'package:clarified_mobile/features/home/widgets/student_faq.dart';
import 'package:clarified_mobile/features/peers/screens/peer_intro.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:clarified_mobile/parents/features/home/widgets/survey_card_parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../main.dart';
import '../../../parents/models/parents.dart';
import '../../../services/app_pref.dart';
import '../../shared/widgets/app_buttombar.dart';
import '../../subjects/widget/completed_topic.dart';
import '../../subjects/widget/subject_list.dart';
import '../widgets/survey_card.dart';

class HomePage extends ConsumerWidget {
   HomePage({
    super.key,
  });

  List<String> languageName = ["English", "Hindi", "Marathi"];
  String selectedLanguage = 'English';
  String languageCode = '';

  @override
  Widget build(BuildContext context, ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: profile.when(
                data: (u) => CircleAvatar(
      radius: 12,
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left:8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(45),
          child: CachedNetworkImage(
              imageUrl: u.profileUrl ?? "",
              errorWidget: (url, err, st) {
                return Image.asset(
                  u.gender == 'male'
                      ? "assets/defalut_profile_male.png"
                      : "assets/default_profile_female.png",
                );
              }),
        ),
      ),
    ),
                error: (e, st) {
                  return const Icon(Icons.account_circle_outlined);
                },
                loading: () => const Icon(Icons.account_circle_outlined),
        ),
        titleSpacing: 0,
        leadingWidth: 42.0,
        toolbarHeight: 70,
        actions: [
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
                    return StudentFAQPopUp(
                      widgetRef: ref,
                    );
                  });
            },
            icon: const Icon(
              Icons.help_outline_outlined,
            ),
          ),
          IconButton(
            onPressed: () => GoRouter.of(context).pushNamed("student-notification"),
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          ),
          
        ],
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "${AppLocalizations.of(context)!.hello}\n", style: TextStyle(fontSize: 12)),
                profile.when(
                  data: (u) => TextSpan(text: u.firstName,),
                  error: (e, st) {
                    print(st);
                    return TextSpan(text: AppLocalizations.of(context)!.error_loading_user);
                  },
                  loading: () => const TextSpan(text: "---"),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8,
            ),
            decoration: ShapeDecoration(
              color: Colors.white,
              shadows: const [
                BoxShadow(
                  color: Colors.blueGrey,
                  offset: Offset(0, 1),
                ),
              ],
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.total_xp_available),
                Center(
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFEFBE8),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFFDE272),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => print("ICONS"),
                      icon: SvgPicture.asset(
                        "assets/svg/crown.svg",
                        theme: const SvgTheme(
                          currentColor: Color(0xFFFAC515),
                        ),
                      ),
                      label: profile.when(
                        data: (u) => Text("${u.balance.current}"),
                        error: (e, st) {
                          return const Text("0");
                        },
                        loading: () => const Text("-"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16,
            ),
            child: SurveyCard(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10,
            ),
            child: const CompletedTopicCard(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 32.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.subjects),
                    TextButton(
                      onPressed: () => GoRouter.of(context).push("/subjects"),
                      child: Text(AppLocalizations.of(context)!.view_all),
                    )
                  ],
                ),
                const SubjectListView(
                  limit: 6,
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: const AppNavBar(
        selected: 'home',
      ),
    );
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
