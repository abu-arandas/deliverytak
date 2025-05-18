import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../models/delivery_schedule.dart';

class DeliveryScheduleService {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  DeliveryScheduleService([
    FirebaseFirestore? firestore,
    Logger? logger,
  ])  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger('DeliveryScheduleService');

  Future<DeliverySchedule> createSchedule({
    required String deliveryId,
    required String driverId,
    required DateTime scheduledTime,
    String? notes,
  }) async {
    try {
      _logger.info('Creating schedule for delivery: $deliveryId');

      final schedule = DeliverySchedule(
        id: '',
        deliveryId: deliveryId,
        driverId: driverId,
        scheduledTime: scheduledTime,
        status: 'pending',
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final docRef = await _firestore.collection('delivery_schedules').add(schedule.toMap());
      final createdSchedule = schedule.copyWith(id: docRef.id);

      _logger.info('Schedule created successfully');
      return createdSchedule;
    } catch (e) {
      _logger.severe('Error creating schedule: $e');
      rethrow;
    }
  }

  Future<DeliverySchedule> updateScheduleStatus({
    required String scheduleId,
    required String status,
  }) async {
    try {
      _logger.info('Updating schedule status: $scheduleId');

      final docRef = _firestore.collection('delivery_schedules').doc(scheduleId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Schedule not found');
      }

      final schedule = DeliverySchedule.fromMap(doc.data()!);
      final updatedSchedule = schedule.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      await docRef.update(updatedSchedule.toMap());

      _logger.info('Schedule status updated successfully');
      return updatedSchedule;
    } catch (e) {
      _logger.severe('Error updating schedule status: $e');
      rethrow;
    }
  }

  Stream<List<DeliverySchedule>> getDriverSchedules(String driverId) {
    _logger.info('Getting schedules for driver: $driverId');

    return _firestore
        .collection('delivery_schedules')
        .where('driverId', isEqualTo: driverId)
        .orderBy('scheduledTime')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => DeliverySchedule.fromMap(doc.data())).toList());
  }

  Future<DeliverySchedule> getSchedule(String scheduleId) async {
    try {
      _logger.info('Getting schedule: $scheduleId');

      final doc = await _firestore.collection('delivery_schedules').doc(scheduleId).get();

      if (!doc.exists) {
        throw Exception('Schedule not found');
      }

      return DeliverySchedule.fromMap(doc.data()!);
    } catch (e) {
      _logger.severe('Error getting schedule: $e');
      rethrow;
    }
  }

  Future<List<DeliverySchedule>> getSchedulesByDateRange({
    required String driverId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      _logger.info('Getting schedules for driver: $driverId');

      final querySnapshot = await _firestore
          .collection('delivery_schedules')
          .where('driverId', isEqualTo: driverId)
          .where('scheduledTime', isGreaterThanOrEqualTo: startDate)
          .where('scheduledTime', isLessThanOrEqualTo: endDate)
          .orderBy('scheduledTime')
          .get();

      return querySnapshot.docs.map((doc) => DeliverySchedule.fromMap(doc.data())).toList();
    } catch (e) {
      _logger.severe('Error getting schedules: $e');
      rethrow;
    }
  }

  Future<void> cancelSchedule(String scheduleId) async {
    try {
      _logger.info('Cancelling schedule: $scheduleId');

      final docRef = _firestore.collection('delivery_schedules').doc(scheduleId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Schedule not found');
      }

      await docRef.update({
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.info('Schedule cancelled successfully');
    } catch (e) {
      _logger.severe('Error cancelling schedule: $e');
      rethrow;
    }
  }
}
