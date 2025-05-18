import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class DriverService {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  DriverService([
    FirebaseFirestore? firestore,
    Logger? logger,
  ])  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger('DriverService');

  Future<void> updateDriverStatus({
    required String driverId,
    required String status,
  }) async {
    try {
      _logger.info('Updating driver status: $driverId');

      await _firestore.collection('drivers').doc(driverId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.info('Driver status updated successfully');
    } catch (e) {
      _logger.severe('Error updating driver status: $e');
      rethrow;
    }
  }

  Future<void> updateDriverLocation({
    required String driverId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      _logger.info('Updating driver location: $driverId');

      await _firestore.collection('drivers').doc(driverId).update({
        'location': GeoPoint(latitude, longitude),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.info('Driver location updated successfully');
    } catch (e) {
      _logger.severe('Error updating driver location: $e');
      rethrow;
    }
  }

  Future<void> updateDriverProfile({
    required String driverId,
    required Map<String, dynamic> data,
  }) async {
    try {
      _logger.info('Updating driver profile: $driverId');

      await _firestore.collection('drivers').doc(driverId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.info('Driver profile updated successfully');
    } catch (e) {
      _logger.severe('Error updating driver profile: $e');
      rethrow;
    }
  }

  Stream<DocumentSnapshot> getDriverStream(String driverId) {
    _logger.info('Getting driver stream: $driverId');

    return _firestore.collection('drivers').doc(driverId).snapshots();
  }

  Future<DocumentSnapshot> getDriver(String driverId) async {
    try {
      _logger.info('Getting driver: $driverId');

      final doc = await _firestore.collection('drivers').doc(driverId).get();

      if (!doc.exists) {
        throw Exception('Driver not found');
      }

      return doc;
    } catch (e) {
      _logger.severe('Error getting driver: $e');
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> getAvailableDrivers() async {
    try {
      _logger.info('Getting available drivers');

      final querySnapshot = await _firestore.collection('drivers').where('status', isEqualTo: 'available').get();

      return querySnapshot.docs;
    } catch (e) {
      _logger.severe('Error getting available drivers: $e');
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> getDriversByStatus(String status) async {
    try {
      _logger.info('Getting drivers by status: $status');

      final querySnapshot = await _firestore.collection('drivers').where('status', isEqualTo: status).get();

      return querySnapshot.docs;
    } catch (e) {
      _logger.severe('Error getting drivers by status: $e');
      rethrow;
    }
  }
}
