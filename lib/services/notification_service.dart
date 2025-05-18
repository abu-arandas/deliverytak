import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final Logger _logger;

  NotificationService([
    Logger? logger,
  ])  : _messaging = FirebaseMessaging.instance,
        _localNotifications = FlutterLocalNotificationsPlugin(),
        _logger = logger ?? Logger('NotificationService') {
    tz.initializeTimeZones();
  }

  Future<void> initialize() async {
    try {
      _logger.info('Initializing notification service');

      // Request permission for notifications
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Initialize local notifications
      const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettingsIOS = DarwinInitializationSettings();
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      _logger.info('Notification service initialized successfully');
    } catch (e) {
      _logger.severe('Error initializing notification service: $e');
      rethrow;
    }
  }

  Future<void> scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    Map<String, dynamic>? payload,
  }) async {
    try {
      _logger.info('Scheduling notification: $id');

      final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

      await _localNotifications.zonedSchedule(
        id.hashCode,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'schedule_channel',
            'Schedule Notifications',
            channelDescription: 'Notifications for scheduled deliveries',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload?.toString(),
      );

      _logger.info('Notification scheduled successfully');
    } catch (e) {
      _logger.severe('Error scheduling notification: $e');
      rethrow;
    }
  }

  Future<void> cancelNotification(String id) async {
    try {
      _logger.info('Cancelling notification: $id');

      await _localNotifications.cancel(id.hashCode);

      _logger.info('Notification cancelled successfully');
    } catch (e) {
      _logger.severe('Error cancelling notification: $e');
      rethrow;
    }
  }

  Future<void> sendNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    try {
      _logger.info('Sending notification: $title');

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.hashCode,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'schedule_channel',
            'Schedule Notifications',
            channelDescription: 'Notifications for scheduled deliveries',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: payload?.toString(),
      );

      _logger.info('Notification sent successfully');
    } catch (e) {
      _logger.severe('Error sending notification: $e');
      rethrow;
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    _logger.info('Notification tapped: \\${response.payload}');
    if (response.payload != null && response.payload!.isNotEmpty) {
      // Parse payload and handle navigation or logic
      // Example: Navigate to a specific screen based on payload
      // final data = jsonDecode(response.payload!);
      // NavigationService.instance.navigateTo(data['route'], arguments: data);
      _logger.info('Parsed payload: \\${response.payload}');
    }
    // You can add more logic here as needed
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _logger.info('Received foreground message: ${message.messageId}');

    await sendNotification(
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Log the background message
  print('Handling a background message: \\${message.messageId}');
  // Optionally, show a local notification
  // You can use FlutterLocalNotificationsPlugin here if needed
  // For example, re-initialize plugins and show notification
}
