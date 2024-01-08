import 'package:clarified_mobile/model/user.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupFirebase() async {
    // Request permission for notifications on iOS
    await _firebaseMessaging.requestPermission();

    // Get the token
    String? token = await _firebaseMessaging.getToken();
    print('Firebase Token: $token');

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.body}');
      _showNotification(message);
      // Handle the received message
    });

    // Handle when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Message opened from terminated state: ${message.notification?.body}');
      _showNotification(message);
      // Handle the opened message
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _showNotification(RemoteMessage messageData) {
    // Use awesome_notifications to show notifications
    print('+++?>>${messageData}');
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: messageData.notification?.title ?? 'Notification Title',
        body: messageData.notification?.body ?? 'Notification Body',
      ),
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.notification?.body}");
    // Handle the background message and show notification
    NotificationService()._showNotification(message);
  }

  Future<void> updateTokenOnLogin(String userType, WidgetRef ref) async {
    // Call this function when the user logs in
    String? token = await _firebaseMessaging.getToken();
    print('Updated Firebase Token on login: $token');
    if (userType == 'parent') {
      updateParentTokenProvider(token ?? "", ref);
    }

    if (userType == 'student') {
      updateStudentTokenProvider(token ?? "", ref);
    }

    if(userType == 'teacher'){
      
    }
    // You can send the updated token to your server or perform any additional logic here
  }

  Future<void> sendNotification(
      {required String title,
      required String message,
      required String token}) async {
    try {
      Dio dio = Dio(BaseOptions(
        contentType: 'application/json', // Added contentType here
      ));
      dio.options.headers['Authorization'] =
          'key=AAAAPui3b0c:APA91bGrlwZURhhTZK_8SWcmJFx8h1bWRsdZ_VMelSXONMNoVMvBUfZOBmLAKcYUFLz5JQ9rvS9FF1Vf0-aSGihcY3GscMKxUj1VtlDkkmvZKimlrERNysuo-iKwb1cLwO2GaOqVa8Iz';
      print(dio.options.headers);
      var res = await dio.post('https://fcm.googleapis.com/fcm/send', data: {
        "to": token,
        "notification": {"title": title, "body": message}
      });
    } on DioException catch (e) {
      print(e);
      print(e.type);
      print(e.stackTrace);
    }
  }
}
