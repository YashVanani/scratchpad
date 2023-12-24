import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/features/notification/screen/notification_setting.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:clarified_mobile/parents/models/notification.dart' as n;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class StudentNotificationScreen extends ConsumerWidget {
  const StudentNotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(studentNotificationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
            // Add your onPressed code here!
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add your onPressed code here!
              Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentNotificationSettingsScreen()));
              // GoRouter.of(context).pushNamed('student-notification-settings');
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: notification.when(
              data: (d) => Column(children:d.map((e) => NotificationCard(notification: e,)).toList()),
              error: (e, h) => Text(e.toString()),
              loading: () => SizedBox())),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification
  });
  final n.Notification notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: const Color(0xffE6F8F9),
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                    height: 40,
                    width: 40,
                    child: SvgPicture.asset(
                      'assets/svg/notification.svg',
                      fit: BoxFit.scaleDown,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
               SizedBox(
                width: MediaQuery.of(context).size.width*0.70,
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.message??""),
                    Text(
                     notification.createdAt?.toDate().toString().substring(0, 10)??'',
                      style: TextStyle(fontSize: 11, color: greyTextColor),
                    )
                  ],
                               ),
               ),
            ],
          ),
          const Divider(
            color: greyTextColor,
            thickness: 0.3,
          )
        ],
      ),
    );
  }
}
