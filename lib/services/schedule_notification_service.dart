import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../models/delivery_schedule.dart';
import 'notification_service.dart';

class ScheduleNotificationService {
  final FirebaseFirestore firestore;
  final NotificationService _notificationService;
  final Logger _logger;

  ScheduleNotificationService(
    this.firestore,
    this._notificationService, [
    Logger? logger,
  ]) : _logger = logger ?? Logger('ScheduleNotificationService');

  Future<void> scheduleNotification({
    required String driverId,
    required DeliverySchedule schedule,
    required Duration notificationTime,
  }) async {
    try {
      _logger.info('Scheduling notification for delivery ${schedule.deliveryId}');

      final notificationTime = schedule.scheduledTime.subtract(const Duration(minutes: 30));
      final notificationId = 'schedule_${schedule.id}';

      await _notificationService.scheduleNotification(
        id: notificationId,
        title: 'Upcoming Delivery',
        body: 'You have a delivery scheduled in 30 minutes (Delivery #${schedule.deliveryId})',
        scheduledTime: notificationTime,
        payload: {
          'type': 'schedule',
          'scheduleId': schedule.id,
          'deliveryId': schedule.deliveryId,
        },
      );

      _logger.info('Notification scheduled successfully');
    } catch (e) {
      _logger.severe('Error scheduling notification: $e');
      rethrow;
    }
  }

  Future<void> cancelNotification(String scheduleId) async {
    try {
      _logger.info('Cancelling notification for schedule $scheduleId');

      final notificationId = 'schedule_$scheduleId';
      await _notificationService.cancelNotification(notificationId);

      _logger.info('Notification cancelled successfully');
    } catch (e) {
      _logger.severe('Error cancelling notification: $e');
      rethrow;
    }
  }

  Future<void> updateNotification({
    required String scheduleId,
    required DeliverySchedule schedule,
  }) async {
    try {
      _logger.info('Updating notification for schedule $scheduleId');

      await cancelNotification(scheduleId);
      await scheduleNotification(
        driverId: schedule.driverId,
        schedule: schedule,
        notificationTime: const Duration(minutes: 30),
      );

      _logger.info('Notification updated successfully');
    } catch (e) {
      _logger.severe('Error updating notification: $e');
      rethrow;
    }
  }

  Future<void> sendImmediateNotification({
    required String driverId,
    required DeliverySchedule schedule,
    required String message,
  }) async {
    try {
      _logger.info('Sending immediate notification for schedule ${schedule.id}');

      await _notificationService.sendNotification(
        title: 'Schedule Update',
        body: message,
        payload: {
          'type': 'schedule_update',
          'scheduleId': schedule.id,
          'deliveryId': schedule.deliveryId,
        },
      );

      _logger.info('Immediate notification sent successfully');
    } catch (e) {
      _logger.severe('Error sending immediate notification: $e');
      rethrow;
    }
  }
}
