import 'package:clarified_mobile/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
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
              GoRouter.of(context).pushNamed('parents-notification-settings');
            },
          ),
        
        ],
        
      centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Column(children: [
          NotificationCard(),
           NotificationCard(),
            NotificationCard()
        ]),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      child: Column(
        children: [
          Row(children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xffE6F8F9),
                borderRadius: BorderRadius.circular(10)
              ),
              child: SizedBox(height: 40,width: 40,child: SvgPicture.asset( 'assets/svg/notification.svg',fit: BoxFit.scaleDown,)),
            ),
            const SizedBox(width: 10,),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("90 XP added for completing survey."),
                Text('03 OCT 23, 12:07 PM',style:TextStyle(fontSize: 11,color: greyTextColor) ,)
              ],
            ),
          ],),
          const Divider(color: greyTextColor,thickness: 0.3,)
        ],
      ),
    );
  }
}