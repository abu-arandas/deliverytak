import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../models/delivery.dart';

class DeliveryService {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  DeliveryService({
    required FirebaseFirestore firestore,
    Logger? logger,
  })  : _firestore = firestore,
        _logger = logger ?? Logger('DeliveryService');

  Future<Delivery> createDelivery({
    required String orderId,
    required String userId,
    required String driverId,
    String? estimatedDeliveryTime,
  }) async {
    try {
      _logger.info('Creating delivery for order $orderId');

      final delivery = Delivery(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        orderId: orderId,
        userId: userId,
        driverId: driverId,
        status: DeliveryStatus.pending,
        estimatedDeliveryTime: estimatedDeliveryTime,
        updates: [
          DeliveryUpdate(
            status: DeliveryStatus.pending,
            message: 'Delivery created',
            timestamp: DateTime.now(),
          ),
        ],
        pickup: GeoPoint(0, 0), // TODO
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('deliveries').doc(delivery.id).set(delivery.toMap());

      _logger.info('Delivery created successfully for order $orderId');
      return delivery;
    } catch (e) {
      _logger.severe('Error creating delivery for order $orderId: $e');
      rethrow;
    }
  }

  Future<Delivery> updateDeliveryStatus({
    required String deliveryId,
    required DeliveryStatus status,
    String? message,
  }) async {
    try {
      _logger.info('Updating delivery $deliveryId status to $status');

      final deliveryRef = _firestore.collection('deliveries').doc(deliveryId);
      final deliveryDoc = await deliveryRef.get();

      if (!deliveryDoc.exists) {
        throw Exception('Delivery not found');
      }

      final delivery = Delivery.fromMap(deliveryDoc.data()!);
      final update = DeliveryUpdate(
        status: status,
        message: message ?? 'Status updated to $status',
        timestamp: DateTime.now(),
      );

      await deliveryRef.update({
        'status': status.toString(),
        'updates': FieldValue.arrayUnion([update.toMap()]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.info('Delivery $deliveryId status updated successfully');
      return delivery.copyWith(
        status: status,
        updates: [...delivery.updates, update],
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      _logger.severe('Error updating delivery status for delivery $deliveryId: $e');
      rethrow;
    }
  }

  Future<void> updateDeliveryLocation({
    required String deliveryId,
    required GeoPoint location,
  }) async {
    try {
      _logger.info('Updating delivery location for delivery $deliveryId');

      final deliveryRef = _firestore.collection('deliveries').doc(deliveryId);
      final deliveryDoc = await deliveryRef.get();

      if (!deliveryDoc.exists) {
        throw Exception('Delivery not found');
      }

      final delivery = Delivery.fromMap(deliveryDoc.data()!);
      final update = DeliveryUpdate(
        status: delivery.status,
        message: 'Location updated',
        timestamp: DateTime.now(),
        location: location,
      );

      final updatedDelivery = delivery.copyWith(
        currentLocation: location,
        updates: [...delivery.updates, update],
        updatedAt: DateTime.now(),
      );

      await deliveryRef.update(updatedDelivery.toMap());

      _logger.info('Delivery location updated successfully for delivery $deliveryId');
    } catch (e) {
      _logger.severe('Error updating delivery location for delivery $deliveryId', e);
      rethrow;
    }
  }

  Future<void> markDeliveryAsDelivered({
    required String deliveryId,
    required String actualDeliveryTime,
  }) async {
    try {
      _logger.info('Marking delivery as delivered for delivery $deliveryId');

      final deliveryRef = _firestore.collection('deliveries').doc(deliveryId);
      final deliveryDoc = await deliveryRef.get();

      if (!deliveryDoc.exists) {
        throw Exception('Delivery not found');
      }

      final delivery = Delivery.fromMap(deliveryDoc.data()!);
      final update = DeliveryUpdate(
        status: DeliveryStatus.delivered,
        message: 'Package delivered',
        timestamp: DateTime.now(),
        location: delivery.currentLocation,
      );

      final updatedDelivery = delivery.copyWith(
        status: DeliveryStatus.delivered,
        actualDeliveryTime: actualDeliveryTime,
        updates: [...delivery.updates, update],
        updatedAt: DateTime.now(),
      );

      await deliveryRef.update(updatedDelivery.toMap());

      _logger.info('Delivery marked as delivered successfully for delivery $deliveryId');
    } catch (e) {
      _logger.severe('Error marking delivery as delivered for delivery $deliveryId', e);
      rethrow;
    }
  }

  Future<void> markDeliveryAsFailed({
    required String deliveryId,
    required String failureReason,
  }) async {
    try {
      _logger.info('Marking delivery as failed for delivery $deliveryId');

      final deliveryRef = _firestore.collection('deliveries').doc(deliveryId);
      final deliveryDoc = await deliveryRef.get();

      if (!deliveryDoc.exists) {
        throw Exception('Delivery not found');
      }

      final delivery = Delivery.fromMap(deliveryDoc.data()!);
      final update = DeliveryUpdate(
        status: DeliveryStatus.failed,
        message: 'Delivery failed: $failureReason',
        timestamp: DateTime.now(),
        location: delivery.currentLocation,
      );

      final updatedDelivery = delivery.copyWith(
        status: DeliveryStatus.failed,
        failureReason: failureReason,
        updates: [...delivery.updates, update],
        updatedAt: DateTime.now(),
      );

      await deliveryRef.update(updatedDelivery.toMap());

      _logger.info('Delivery marked as failed successfully for delivery $deliveryId');
    } catch (e) {
      _logger.severe('Error marking delivery as failed for delivery $deliveryId', e);
      rethrow;
    }
  }

  Stream<Delivery> getDeliveryStream(String deliveryId) {
    return _firestore.collection('deliveries').doc(deliveryId).snapshots().map((doc) => Delivery.fromMap(doc.data()!));
  }

  Future<List<Delivery>> getDriverDeliveries(String driverId) async {
    try {
      _logger.info('Fetching deliveries for driver $driverId');

      final deliveriesSnapshot = await _firestore
          .collection('deliveries')
          .where('driverId', isEqualTo: driverId)
          .orderBy('createdAt', descending: true)
          .get();

      _logger.info('Fetched ${deliveriesSnapshot.docs.length} deliveries for driver $driverId');
      return deliveriesSnapshot.docs.map((doc) => Delivery.fromMap(doc.data())).toList();
    } catch (e) {
      _logger.severe('Error fetching deliveries for driver $driverId: $e');
      rethrow;
    }
  }

  Future<List<Delivery>> getUserDeliveries(String userId) async {
    try {
      _logger.info('Fetching deliveries for user $userId');

      final deliveriesSnapshot = await _firestore
          .collection('deliveries')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _logger.info('Fetched ${deliveriesSnapshot.docs.length} deliveries for user $userId');
      return deliveriesSnapshot.docs.map((doc) => Delivery.fromMap(doc.data())).toList();
    } catch (e) {
      _logger.severe('Error fetching deliveries for user $userId: $e');
      rethrow;
    }
  }

  Stream<List<Delivery>> getDeliveriesByUserId(String userId) {
    return _firestore
        .collection('deliveries')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Delivery.fromMap(doc.data())).toList());
  }

  Stream<List<Delivery>> getDeliveriesByDriverId(String driverId) {
    return _firestore
        .collection('deliveries')
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Delivery.fromMap(doc.data())).toList());
  }
}
