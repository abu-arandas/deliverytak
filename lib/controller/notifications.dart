// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';

import '/exports.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  static NotificationController instance = Get.find();

  @override
  void onInit() {
    super.onInit();

    permission();
  }

  permission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    while (settings.authorizationStatus != AuthorizationStatus.authorized) {
      settings;
    }

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'mychanel',
        'mychanel',
        styleInformation: bigTextStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails(),
      );

      await FlutterLocalNotificationsPlugin().show(
          0,
          message.notification!.title,
          message.notification!.body,
          notificationDetails);
    });
  }

  Future<void> sendMessage({
    required BuildContext context,
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAr0yce-M:APA91bFYK9k3Wq_5VO9fkhFv4iu-SCjgzWJKPMFEZxeNH7qSwccuP9uAFglkMyCtE0c4G48Ac7XE4fhEVgz22s_RDJ8mo-nIBgqGQrRVePA0bvQ2SPuZjESPxDVnOzd5JadC7FYJNBrc'
              },
              body: jsonEncode(<String, dynamic>{
                'to': token,
                'notification': <String, dynamic>{'title': title, 'body': body},
                'priority': 'high',
                'data': {
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'id': '1',
                  'status': 'done',
                  'message': title,
                }
              }));

      if (response.statusCode == 200) {
      } else {
        errorSnackBar(context, 'Somethig is Wrong');
      }
    } catch (error) {
      errorSnackBar(context, 'Somethig is Wrong');
    }
  }
}
