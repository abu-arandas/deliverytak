import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../models/delivery_schedule.dart';

class ScheduleConflictService {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  ScheduleConflictService([
    FirebaseFirestore? firestore,
    Logger? logger,
  ])  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger('ScheduleConflictService');

  Future<List<DeliverySchedule>> checkConflicts({
    required String driverId,
    required DateTime scheduledTime,
  }) async {
    try {
      _logger.info('Checking conflicts for driver: $driverId');

      final startTime = scheduledTime.subtract(const Duration(hours: 1));
      final endTime = scheduledTime.add(const Duration(hours: 1));

      final querySnapshot = await _firestore
          .collection('delivery_schedules')
          .where('driverId', isEqualTo: driverId)
          .where('scheduledTime', isGreaterThanOrEqualTo: startTime)
          .where('scheduledTime', isLessThanOrEqualTo: endTime)
          .where('status', whereIn: ['pending', 'in_progress']).get();

      final conflicts = querySnapshot.docs.map((doc) => DeliverySchedule.fromMap(doc.data())).toList();

      _logger.info('Found ${conflicts.length} conflicts');
      return conflicts;
    } catch (e) {
      _logger.severe('Error checking conflicts: $e');
      rethrow;
    }
  }

  Future<List<DeliverySchedule>> getConflictingSchedules({
    required String driverId,
    required DateTime scheduledTime,
  }) async {
    try {
      _logger.info('Getting conflicting schedules for driver: $driverId');

      final startTime = scheduledTime.subtract(const Duration(hours: 1));
      final endTime = scheduledTime.add(const Duration(hours: 1));

      final querySnapshot = await _firestore
          .collection('delivery_schedules')
          .where('driverId', isEqualTo: driverId)
          .where('scheduledTime', isGreaterThanOrEqualTo: startTime)
          .where('scheduledTime', isLessThanOrEqualTo: endTime)
          .where('status', whereIn: ['pending', 'in_progress']).get();

      final conflicts = querySnapshot.docs.map((doc) => DeliverySchedule.fromMap(doc.data())).toList();

      _logger.info('Found ${conflicts.length} conflicting schedules');
      return conflicts;
    } catch (e) {
      _logger.severe('Error getting conflicting schedules: $e');
      rethrow;
    }
  }
}
