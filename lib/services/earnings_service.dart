import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../models/driver_earnings.dart';

class EarningsService {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  EarningsService({
    required FirebaseFirestore firestore,
    Logger? logger,
  })  : _firestore = firestore,
        _logger = logger ?? Logger('EarningsService');

  Future<DriverEarnings> createEarning({
    required String driverId,
    required double amount,
    required String deliveryId,
  }) async {
    try {
      _logger.info('Creating earning for driver $driverId');

      final earning = DriverEarnings(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        driverId: driverId,
        amount: amount,
        deliveryId: deliveryId,
        date: DateTime.now(),
        status: 'pending',
      );

      await _firestore.collection('earnings').doc(earning.id).set(earning.toMap());

      _logger.info('Earning created successfully for driver $driverId');
      return earning;
    } catch (e) {
      _logger.severe('Error creating earning for driver $driverId: $e');
      rethrow;
    }
  }

  Future<void> updateEarningStatus({
    required String earningId,
    required String status,
    String? paymentMethod,
  }) async {
    try {
      _logger.info('Updating earning status for earning $earningId');

      final updates = {
        'status': status,
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
        if (status == 'completed') 'paidAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('earnings').doc(earningId).update(updates);

      _logger.info('Earning status updated successfully for earning $earningId');
    } catch (e) {
      _logger.severe('Error updating earning status for earning $earningId: $e');
      rethrow;
    }
  }

  Stream<List<DriverEarnings>> getDriverEarnings(String driverId) {
    return _firestore
        .collection('earnings')
        .where('driverId', isEqualTo: driverId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => DriverEarnings.fromMap(doc.data())).toList());
  }

  Future<Map<String, dynamic>> getDriverEarningsSummary(String driverId) async {
    try {
      _logger.info('Getting earnings summary for driver $driverId');

      final earningsSnapshot = await _firestore.collection('earnings').where('driverId', isEqualTo: driverId).get();

      final earnings = earningsSnapshot.docs.map((doc) => DriverEarnings.fromMap(doc.data())).toList();

      final totalEarnings = earnings.fold<double>(0, (total, earning) => total + earning.amount);
      final completedEarnings = earnings.where((e) => e.status == 'completed').fold<double>(
            0,
            (total, earning) => total + earning.amount,
          );
      final pendingEarnings = earnings.where((e) => e.status == 'pending').fold<double>(
            0,
            (total, earning) => total + earning.amount,
          );

      final summary = {
        'totalEarnings': totalEarnings,
        'completedEarnings': completedEarnings,
        'pendingEarnings': pendingEarnings,
        'totalDeliveries': earnings.length,
        'completedDeliveries': earnings.where((e) => e.status == 'completed').length,
        'pendingDeliveries': earnings.where((e) => e.status == 'pending').length,
      };

      _logger.info('Earnings summary retrieved successfully for driver $driverId');
      return summary;
    } catch (e) {
      _logger.severe('Error getting earnings summary for driver $driverId: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDriverEarningsByPeriod(
    String driverId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      _logger.info('Getting earnings by period for driver $driverId');

      final earningsSnapshot = await _firestore
          .collection('earnings')
          .where('driverId', isEqualTo: driverId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .orderBy('date', descending: true)
          .get();

      final earnings = earningsSnapshot.docs.map((doc) => DriverEarnings.fromMap(doc.data())).toList();

      // Group earnings by date
      final Map<String, List<DriverEarnings>> groupedEarnings = {};
      for (var earning in earnings) {
        final date = earning.date.toIso8601String().split('T')[0];
        groupedEarnings.putIfAbsent(date, () => []).add(earning);
      }

      // Calculate daily summaries
      final dailySummaries = groupedEarnings.entries.map((entry) {
        final dailyEarnings = entry.value;
        return {
          'date': entry.key,
          'totalEarnings': dailyEarnings.fold<double>(0, (total, e) => total + e.amount),
          'completedEarnings':
              dailyEarnings.where((e) => e.status == 'completed').fold<double>(0, (total, e) => total + e.amount),
          'pendingEarnings':
              dailyEarnings.where((e) => e.status == 'pending').fold<double>(0, (total, e) => total + e.amount),
          'totalDeliveries': dailyEarnings.length,
          'completedDeliveries': dailyEarnings.where((e) => e.status == 'completed').length,
          'pendingDeliveries': dailyEarnings.where((e) => e.status == 'pending').length,
        };
      }).toList();

      _logger.info('Earnings by period retrieved successfully for driver $driverId');
      return dailySummaries;
    } catch (e) {
      _logger.severe('Error getting earnings by period for driver $driverId: $e');
      rethrow;
    }
  }
}
