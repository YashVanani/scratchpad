import 'package:clarified_mobile/parents/features/widgets/p_bottombar.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../consts/colors.dart';
import '../../../../consts/commonStyle.dart';
import '../../../../consts/imageRes.dart';

final navigatorKeyProvider = StateProvider((_) => GlobalKey());

class ParentProfile extends ConsumerWidget {
  ParentProfile({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoaded = false;
  XFile? profileImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(parentProfileProvider);
    if (!isLoaded) {
      print("+++++++PROFILE NAME ${profile.value?.firstName}");
      nameController.text = profile.value?.firstName ?? '';
      lastNameController.text = profile.value?.lastName ?? '';
      emailController.text = profile.value?.email ?? '';
    }
    isLoaded = true;
    return Scaffold(
        key: ref.watch(navigatorKeyProvider.notifier).state,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                GoRouter.of(context).goNamed('parents-home');
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: Text(
            AppLocalizations.of(context)!.profile_details,
            style: CommonStyle.lexendMediumStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: textMainColor),
          ),
          actions: [
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.logout),
                          content:
                              Text(AppLocalizations.of(context)!.are_you_sure),
                          actions: [
                            TextButton.icon(
                              onPressed: () => Navigator.of(ctx).maybePop(),
                              icon: const Icon(Icons.stop_circle),
                              label: Text(AppLocalizations.of(context)!.no),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(ctx).maybePop();
                                FirebaseAuth.instance.signOut();
                              },
                              icon: const Icon(Icons.check),
                              label: Text(AppLocalizations.of(context)!.yes),
                            ),
                          ],
                        );
                      });
                },
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.logout,style: TextStyle(color:Color(0xffF04438), ),),
                    SizedBox(width: 5,),
                    const Icon(
                      Icons.logout,
                      color: Color(0xffF04438),
                    ),
                      SizedBox(width: 10,),
                  ],
                )),
          ],
        ),
        body: profile.when(
          data: (profileInfo) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            (profileInfo.profileUrl.isNotEmpty ?? false)
                                ? CircleAvatar(
                                    radius: 48,
                                    backgroundColor: purpleColor,
                                    backgroundImage: NetworkImage(
                                        profileInfo.profileUrl ?? "")
                                    // child:  (profileInfo.profileUrl.isNotEmpty??false)?Image.network(profileInfo.profileUrl??""): Image.asset(ImageRes.profileAvtar),
                                    )
                                : CircleAvatar(
                                    radius: 48,
                                    backgroundColor: purpleColor,
                                    backgroundImage:
                                        AssetImage(ImageRes.profileAvtar),
                                    // child:  (profileInfo.profileUrl.isNotEmpty??false)?Image.network(profileInfo.profileUrl??""): Image.asset(ImageRes.profileAvtar),
                                  ),
                            const SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    // barrierDismissible: false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return ChangeImagePopup(ref, context);
                                    },
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xffD0D5DD)),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .change_image,
                                      style: CommonStyle.lexendMediumStyle
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: textMainColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  AppLocalizations.of(context)!.first_name,
                                  style: CommonStyle.lexendMediumStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: textMainColor),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xff98A2B3))),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffF9FAFB),
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!
                                          .enter_name,
                                      hintStyle: CommonStyle.lexendMediumStyle
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: const Color(0xff98A2B3)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5.0, top: 15),
                                child: Text(
                                  AppLocalizations.of(context)!.last_name,
                                  style: CommonStyle.lexendMediumStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: textMainColor),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xff98A2B3))),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: TextField(
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffF9FAFB),
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!
                                          .last_name,
                                      hintStyle: CommonStyle.lexendMediumStyle
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: const Color(0xff98A2B3)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5.0, top: 15),
                                child: Text(
                                  AppLocalizations.of(context)!.email,
                                  style: CommonStyle.lexendMediumStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: textMainColor),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xff98A2B3))),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffF9FAFB),
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(Icons.email),
                                      hintText: 'alex@gmail.com',
                                      hintStyle: CommonStyle.lexendMediumStyle
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: textMainColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return ChangePasswordPopup(context);
                              },
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xffD0D5DD)),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    ImageRes.keyIcon,
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .change_password_capital,
                                    style: CommonStyle.lexendMediumStyle
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: textMainColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            ref.watch(updateProfileProvider(ParentInfo(
                                id: profile.value?.id ?? '',
                                firstName: nameController.text,
                                lastName: lastNameController.text,
                                email: emailController.text,
                                profileUrl: profile.value?.profileUrl ?? '',
                                surveyInbox: profile.value?.surveyInbox ?? [],
                                childrens: ref
                                        .read(parentProfileProvider)
                                        .value
                                        ?.childrens ??
                                    [],
                                inAppNotification: ref
                                        .read(parentProfileProvider)
                                        .value
                                        ?.inAppNotification ??
                                    false,
                                appUpdateNotification: ref
                                        .read(parentProfileProvider)
                                        .value
                                        ?.appUpdateNotification ??
                                    false,
                                favoriteActivities: ref
                                        .read(parentProfileProvider)
                                        .value
                                        ?.favoriteActivities ??
                                    [])));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: greenTextColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.save_change,
                                style: CommonStyle.lexendMediumStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: whiteTextColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (err, st) {
            print([err, st]);
            return const SizedBox();
          },
          loading: () => const CircularProgressIndicator(),
        ),
        bottomNavigationBar: const ParentsBottomBar(
          selected: 'parents-profile',
        ));
  }

  ChangeImagePopup(WidgetRef ref, BuildContext context) {
    return AlertDialog(
      scrollable: true,
      // insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: whiteColor,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      content: Container(
        width: 500,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border.all(
                  color: const Color(0xFFEAECF0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.update_profile_image,
                    style: TextStyle(
                      color: Color(0xFF04686E),
                      fontSize: 10,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                      height: 0.28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all()),
                      child: const Padding(
                        padding: EdgeInsets.all(3),
                        child: Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: InkWell(
                            onTap: () async {
                              /// camera Image
                              await getImage(true, ref);

                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ImageRes.choosePhoto,
                              height: 100,
                            )),
                      ),
                      const VerticalDivider(
                        color: buttonColor,
                        thickness: 1.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: InkWell(
                            onTap: () async {
                              /// picture Gallery
                              await getImage(false, ref);
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ImageRes.choosePhoto,
                              height: 100,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  AppLocalizations.of(context)!.select_files_to_upload,
                  style: CommonStyle.lexendMediumStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: textMainColor),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: greenTextColor),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.update_image,
                    style: CommonStyle.lexendMediumStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: whiteTextColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Get image
  Future getImage(isFromCamera, ref) async {
    try {
      final ImagePicker _picker = ImagePicker();
      if (isFromCamera) {
        /// camera Image
        XFile? photo = await _picker.pickImage(
            source: ImageSource.camera,
            maxWidth: 1280,
            maxHeight: 720,
            imageQuality: 60);
        String rres = await uploadProfileToFirebase(photo!) ?? '';
        ref.read(updateProfileProvider(ParentInfo(
            id: ref.read(parentProfileProvider).value?.id ?? '',
            firstName: nameController.text,
            lastName: lastNameController.text,
            email: emailController.text,
            profileUrl: rres,
            surveyInbox:
                ref.read(parentProfileProvider).value?.surveyInbox ?? [],
            childrens: ref.read(parentProfileProvider).value?.childrens ?? [],
            inAppNotification:
                ref.read(parentProfileProvider).value?.inAppNotification ??
                    false,
            appUpdateNotification:
                ref.read(parentProfileProvider).value?.appUpdateNotification ??
                    false,
            favoriteActivities:
                ref.read(parentProfileProvider).value?.favoriteActivities ??
                    [])));
        print("+++++++>>$rres");
        return true;
      } else {
        /// gallery Image
        final XFile? selectedImages = await _picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 1280,
            maxHeight: 720,
            imageQuality: 60);
        String rres = await uploadProfileToFirebase(selectedImages!) ?? '';
        ref.read(updateProfileProvider(ParentInfo(
            id: ref.read(parentProfileProvider).value?.id ?? '',
            firstName: nameController.text,
            lastName: lastNameController.text,
            email: emailController.text,
            profileUrl: rres,
            surveyInbox:
                ref.read(parentProfileProvider).value?.surveyInbox ?? [],
            childrens: ref.read(parentProfileProvider).value?.childrens ?? [],
            inAppNotification:
                ref.read(parentProfileProvider).value?.inAppNotification ??
                    false,
            appUpdateNotification:
                ref.read(parentProfileProvider).value?.appUpdateNotification ??
                    false,
            favoriteActivities:
                ref.read(parentProfileProvider).value?.favoriteActivities ??
                    [])));
        print("+++++++>>$rres");
        return true;
        //return selectedImages;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  ChangePasswordPopup(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: whiteColor),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border.all(
                  color: const Color(0xFFEAECF0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.change_password_small,
                    style: TextStyle(
                      color: Color(0xFF04686E),
                      fontSize: 12,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                      height: 0.28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all()),
                      child: const Padding(
                        padding: EdgeInsets.all(3),
                        child: Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.current_password,
                      style: CommonStyle.lexendMediumStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: textMainColor),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xff98A2B3))),
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffF9FAFB),
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.password,
                            hintStyle: CommonStyle.lexendMediumStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: const Color(0xff98A2B3)),
                            suffixIcon: const Icon(Icons.remove_red_eye)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 15),
                    child: Text(
                      AppLocalizations.of(context)!.new_password,
                      style: CommonStyle.lexendMediumStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: textMainColor),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xff98A2B3))),
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffF9FAFB),
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.password,
                            hintStyle: CommonStyle.lexendMediumStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: const Color(0xff98A2B3)),
                            suffixIcon: const Icon(Icons.remove_red_eye)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 15),
                    child: Text(
                      AppLocalizations.of(context)!.confirm_password,
                      style: CommonStyle.lexendMediumStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: textMainColor),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xff98A2B3))),
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffF9FAFB),
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.password,
                            hintStyle: CommonStyle.lexendMediumStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: const Color(0xff98A2B3)),
                            suffixIcon: const Icon(Icons.remove_red_eye)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.password_must_contain,
                      style: CommonStyle.lexendMediumStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: textMainColor),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        ImageRes.checkIcon,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        AppLocalizations.of(context)!.min_characters,
                        style: CommonStyle.lexendMediumStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: textMainColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        ImageRes.checkIcon,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .at_least_one_special_characters,
                        style: CommonStyle.lexendMediumStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: textMainColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        ImageRes.checkIcon,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        AppLocalizations.of(context)!.at_least_one_number,
                        style: CommonStyle.lexendMediumStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: textMainColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: greenTextColor),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.save_password,
                    style: CommonStyle.lexendMediumStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: whiteTextColor),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
