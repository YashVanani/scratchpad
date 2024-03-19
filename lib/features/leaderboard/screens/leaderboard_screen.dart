import 'package:clarified_mobile/features/leaderboard/model/leaders.dart';
import 'package:clarified_mobile/features/shared/widgets/profile_photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clarified_mobile/features/shared/widgets/app_buttombar.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  bool leaderGraph = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {getClassId(ref);});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final studentList = ref.watch(
      leaderProvider(leaderGraph ? profile.valueOrNull?.currentClassId : null),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.account_circle_outlined),
        titleSpacing: 0,
        leadingWidth: 42.0,
        toolbarHeight: 70,
        actions: [
          IconButton(
            onPressed: () =>
                GoRouter.of(context).pushNamed("profile-notification"),
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          )
        ],
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context)!.hello,
                style: TextStyle(fontSize: 12),
              ),
              const TextSpan(text: "\n"),
              profile.when(
                data: (u) => TextSpan(text: u.name),
                error: (e, st) {
                  return TextSpan(text: AppLocalizations.of(context)!.error_loading_user);
                },
                loading: () => const TextSpan(text: "---"),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTab(
              menu: [
                (label: AppLocalizations.of(context)!.your_section, tag: AppLocalizations.of(context)!.section),
                (label: AppLocalizations.of(context)!.all_section, tag: AppLocalizations.of(context)!.section_all),
              ],
              callback: (tag) => setState(() {
                leaderGraph = tag == 'section';
              }),
            ),
            const SizedBox(
              height: 15,
            ),
            studentList.when(
              data: (data) {
                if (data?.isNotEmpty != true) {
                  // we should probably never get here
                  return Expanded(
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.no_students_found),
                    ),
                  );
                }
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 12,
                    ),
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            Icons.info_rounded,
                            size: 16,
                            color: Color(0xFFF79009),
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.these_scores_are_not_academic_rankings,
                            style: TextStyle(
                              color: Color(0xFFF79009),
                              fontSize: 12,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        if (leaderGraph)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _LeaderPodium(
                              items: data.take(3).toList(),
                            ),
                          ),
                        ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: data.length -
                              (leaderGraph
                                  // make sure we don't enter negetive while we adjust
                                  ? (data.length > 2 ? 3 : data.length)
                                  : 0),
                          itemBuilder: (ctx, int index) {
                            final idx = index + (leaderGraph ? 3 : 0);
                            final rec = data[idx];

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFEAECF0),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text("${idx + 1}"),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: ProfilePhotoWidget(
                                        photoUrl: rec.profileUrl,
                                        gender: "male",
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(text: rec.name),
                                          TextSpan(
                                            text:
                                                "\n${rec?.score?.overall ?? 0} ${AppLocalizations.of(context)!.points}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (idx < 3)
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: ShapeDecoration(
                                        color: idx == 0
                                            ? const Color(0xFFFAC414)
                                            : idx == 1
                                                ? const Color(0xFFD0D5DD)
                                                : const Color(0xFFF7B279),
                                        shape: const StarBorder.polygon(
                                          sides: 6,
                                          // borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/svg/crown.svg",
                                          width: 20,
                                          height: 20,
                                          theme: const SvgTheme(
                                            currentColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (profile.valueOrNull?.id == rec.id &&
                                      idx > 2)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFE5F7F8),
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            width: 1,
                                            color: Color(0xFF68B1B6),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(166),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.you_capital,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF045E63),
                                          fontSize: 10,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (c, idx) {
                            return const SizedBox(
                              height: 15,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (err, st) {
                print(err);
                print(st);
                return Text(AppLocalizations.of(context)!.error_loading_leader_board);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
            )
          ],
        ),
      ),
      bottomNavigationBar: const AppNavBar(
        selected: 'leaderboard',
      ),
    );
  }
}

class _LeaderPodium extends StatelessWidget {
  final List<LeaderItem?> items;

  const _LeaderPodium({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            children: [
              ProfilePhotoWidget(
                photoUrl: items[1]?.profileUrl,
                gender: "female",
              ),
              Text(
                items[1]?.name ?? AppLocalizations.of(context)!.name,
                textAlign: TextAlign.center,
              ),
              Container(
                height: 127,
                decoration: const ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [
                      Color(0xFF81BAF2),
                      Color(0xFF4881B8),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        width: 47,
                        height: 47,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF4B84BB),
                              fontSize: 20,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFD0D5DD),
                            shape: StarBorder.polygon(
                              sides: 6,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/svg/crown.svg",
                              width: 15,
                              height: 15,
                              theme: const SvgTheme(
                                currentColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${items.elementAtOrNull(1)?.score?.overall ?? 0}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              ProfilePhotoWidget(
                photoUrl: items[0]?.profileUrl,
                gender: "female",
              ),
              Text(
                items[0]?.name ?? AppLocalizations.of(context)!.name,
                textAlign: TextAlign.center,
              ),
              Container(
                  height: 143,
                  decoration: const ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [
                        Color(0xFFF28181),
                        Color(0xFFB84848),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: 47,
                          height: 47,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '1',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF4B84BB),
                                fontSize: 20,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFFAC414),
                              shape: StarBorder.polygon(
                                sides: 6,
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/svg/crown.svg",
                                width: 15,
                                height: 15,
                                theme: const SvgTheme(
                                  currentColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${items.elementAtOrNull(0)?.score?.overall ?? 0}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              ProfilePhotoWidget(
                photoUrl: items[2]?.profileUrl,
                gender: "female",
              ),
              Text(
                items[2]?.name ?? AppLocalizations.of(context)!.name,
                textAlign: TextAlign.center,
              ),
              Container(
                height: 119,
                decoration: const ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [Color(0xFF81F2BB), Color(0xFF48B890)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        width: 47,
                        height: 47,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF4B84BB),
                              fontSize: 20,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFF7B279),
                            shape: StarBorder.polygon(
                              sides: 6,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/svg/crown.svg",
                              width: 15,
                              height: 15,
                              theme: const SvgTheme(
                                currentColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${items.elementAtOrNull(2)?.score?.overall ?? 0}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _sectionTab extends StatefulWidget {
  final List<({String label, String tag})> menu;
  final void Function(String currentTag) callback;

  const _sectionTab({
    super.key,
    required this.menu,
    required this.callback,
  });

  @override
  State<_sectionTab> createState() => _sectionTabState();
}

class _sectionTabState extends State<_sectionTab> {
  String selectedTag = "";

  @override
  void initState() {
    super.initState();
    selectedTag = widget.menu.firstOrNull?.tag ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: const Color(0xFFF5FBFB),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFF52979C),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.menu
            .map(
              (e) => Expanded(
                child: InkWell(
                  onTap: () => setState(() {
                    selectedTag = e.tag;
                    widget.callback(e.tag);
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: selectedTag == e.tag
                        ? ShapeDecoration(
                            color: const Color(0xFF04686E),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Color(0xFF045E63),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )
                        : null,
                    child: Text(
                      e.label.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedTag == e.tag
                            ? Colors.white
                            : const Color(0xFF045E63),
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: selectedTag == e.tag
                            ? FontWeight.normal
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
