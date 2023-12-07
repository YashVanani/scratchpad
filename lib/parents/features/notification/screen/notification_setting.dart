import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Notifications setting'),
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
              padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10),
              child: Text('In this section, you will be able to manage notifications. We will continue to  send you notifications for security reasons.',textAlign: TextAlign.center,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 10),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              SizedBox(width: MediaQuery.of(context).size.width*0.7,child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('In App Notifications',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  Text('You will receive a notification inside the application.',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                ],
              ),),
              Switch(value: true, onChanged: (value){},activeColor: Color(0xff34C759),)
            ],),
          ),

           Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 10),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              SizedBox(width: MediaQuery.of(context).size.width*0.7,child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Update Application',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  Text('You will receive a notification about update application.',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                ],
              ),),
              Switch(value: false, onChanged: (value){},activeColor: Color(0xff34C759),)
            ],),
          )
        ],
      ),
    );
  }
}