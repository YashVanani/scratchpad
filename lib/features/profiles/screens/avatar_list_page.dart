import 'package:cached_network_image/cached_network_image.dart';
import 'package:clarified_mobile/features/profiles/model/avatar.dart';
import 'package:clarified_mobile/features/shared/widgets/page_buttom_slug.dart';
import 'package:clarified_mobile/features/shared/widgets/unlock_pop_up.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChooseAvatarPage extends ConsumerStatefulWidget {
  const ChooseAvatarPage({super.key});
  @override
  ConsumerState<ChooseAvatarPage> createState() => _ChooseAvatarPageState();
}

class _ChooseAvatarPageState extends ConsumerState<ChooseAvatarPage> {
  String currentMode = "free";
  String selectedItem = "";
  String profileAvatar = "";

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    profileAvatar = selectedItem = profile.value?.avatar ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final avatars = ref.watch(avatarListProvider);
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: const Color(0xFFFCFCFD),
        title: const Text("Choose an Avatar"),
      ),
      body: Container(
        color: const Color(0xFFFCFCFD),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _AvatarTabs(
                onTagSelected: (tag) {
                  setState(() => currentMode = tag);
                },
                selectedTag: currentMode,
                tabs: const [
                  (tag: "free", label: "Free Avatars"),
                  (tag: "paid", label: "Redeem Avatars"),
                ],
              ),
            ),
            Expanded(
              child: avatars.when(
                data: (avatarFullList) {
                  if (avatarFullList.isEmpty) {
                    return Center(
                      child: Text("No $currentMode avatars available"),
                    );
                  }

                  final displayList = avatarFullList
                      .where((a) => a.mode == currentMode)
                      .toList();

                  return GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: displayList.length,
                    itemBuilder: (ctx, idx) {
                      final avatar = displayList[idx];
                      final canUse = avatar.mode == 'free' ||
                          !(profile.valueOrNull?.unlockedAvatars
                                  .contains(avatar.id) !=
                              true);
                      return _avatarItem(
                        onClicked: () => setState(() {
                          if (canUse) {
                            selectedItem = avatar.id;
                            return;
                          }
                          if (avatar.price > profile.value!.balance.current) {
                            Fluttertoast.showToast(msg: "Not Enough balance");
                            return;
                          }

                          showModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return UnlockPopUp(
                                  message:
                                      "Are you sure you want to spend ${avatar.price}xp to unlock this avatar?",
                                  onConfirmed: () async {
                                    await ref
                                        .read(
                                          avatarListManagerProvider.notifier,
                                        )
                                        .purchaseAvatarItem(avatar: avatar);
                                  },
                                );
                              });
                        }),
                        selected: selectedItem == avatar.id,
                        avatar: avatar,
                        alreadyOwned: canUse,
                      );
                    },
                  );
                },
                error: (err, st) {
                  return const SizedBox.expand(
                    child: Text("Error: Load failed"),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF04686E),
                disabledBackgroundColor: const Color(0xAA04686E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFF04686E),
                ),
                elevation: 3,
              ),
              onPressed:
                  selectedItem.isNotEmpty && selectedItem != profileAvatar
                      ? () async {
                          final avatar = avatars.value
                              ?.firstWhere((e) => e.id == selectedItem);
                          if (avatar == null) return;
                          await ref
                              .read(
                                avatarListManagerProvider.notifier,
                              )
                              .applyAvatar(avatar: avatar);

                          Navigator.of(context).maybePop();
                        }
                      : null,
              child: const Text(
                "APPLY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const PageButtomSlug(),
    );
  }
}

class _avatarItem extends StatelessWidget {
  const _avatarItem({
    super.key,
    required this.avatar,
    required this.alreadyOwned,
    this.selected = false,
    required this.onClicked,
  });

  final Avatar avatar;
  final bool alreadyOwned;
  final bool selected;
  final Function onClicked;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.all(8.0),
      ),
      onPressed: () {
        onClicked();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: CachedNetworkImage(
                imageUrl: avatar.url,
              ),
            ),
          ),
          if (avatar.mode != 'free' && !alreadyOwned)
            Align(
              alignment: const FractionalOffset(0.5, 1.1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 8,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFFEF7C3),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color(0xFFFEF7C3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // color: const Color(0xFFFEF7C3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/lock_icon.svg',
                      theme: const SvgTheme(
                        currentColor: Color(0xFFCA8504),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${avatar.price}XP",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFCA8504),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (selected)
            Align(
              alignment: const FractionalOffset(1, 0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    // side: const BorderSide(
                    //   color: Colors.white,
                    // ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4BAE4F),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarTabs extends StatelessWidget {
  final List<({String tag, String label})> tabs;
  final Function(String tag) onTagSelected;
  final String selectedTag;

  const _AvatarTabs({
    super.key,
    required this.tabs,
    required this.selectedTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(2),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: tabs.map((t) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 8,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: t.tag == selectedTag
                      ? const Color(0xFF04686E)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () => onTagSelected(t.tag),
                child: Text(
                  t.label,
                  style: TextStyle(
                    color: t.tag == selectedTag
                        ? Colors.white
                        : const Color(0xFF475467),
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
