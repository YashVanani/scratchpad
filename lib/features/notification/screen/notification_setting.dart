import 'package:clarified_mobile/model/user.dart';
import 'package:clarified_mobile/parents/features/profile/screen/p_profile.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final studentKeyProvider = StateProvider((_) => GlobalKey());

class StudentNotificationSettingsScreen extends ConsumerWidget {
  const StudentNotificationSettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final profile = ref.watch(profileProvider);
    return Scaffold(
      key: ref.read(studentKeyProvider.notifier).state,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notifications_setting),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
            // Add your onPressed code here!
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                AppLocalizations.of(context)!.in_this_section,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.in_app_notifications,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .inside_application_notifications,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Switch(value: profile.asData?.value.inAppNotification??true, onChanged: (value){
                 
                   updateStudentInAppNotificationProvider(value,ref);
                   
              },activeColor: Color(0xff34C759),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.update_application,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .update_application_notifications,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Switch(value: profile.asData?.value.appUpdateNotification??true, onChanged: (value){
               print(value);
               updateStudentAppUpdateNotification(value,ref);
              },activeColor: Color(0xff34C759),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
