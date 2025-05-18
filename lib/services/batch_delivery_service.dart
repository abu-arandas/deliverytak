import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/batch_delivery.dart';
import '../models/batch_delivery_details.dart';
import '../models/delivery.dart';

class BatchDeliveryService {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  BatchDeliveryService({
    FirebaseFirestore? firestore,
    Logger? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger('BatchDeliveryService');

  Future<BatchDelivery> createBatchDelivery({
    required String driverId,
    required List<String> deliveryIds,
    String? notes,
  }) async {
    try {
      final batchRef = _firestore.collection('batch_deliveries').doc();
      final now = DateTime.now();

      final batch = BatchDelivery(
        id: batchRef.id,
        driverId: driverId,
        deliveryIds: deliveryIds,
        status: 'pending',
        notes: notes,
        createdAt: now,
        updatedAt: now,
      );

      await batchRef.set(batch.toMap());
      _logger.info('Created batch delivery: ${batch.id}');
      return batch;
    } catch (e) {
      _logger.severe('Error creating batch delivery: $e');
      rethrow;
    }
  }

  Future<BatchDelivery> updateBatchStatus({
    required String batchId,
    required String status,
  }) async {
    try {
      final batchRef = _firestore.collection('batch_deliveries').doc(batchId);
      final batchDoc = await batchRef.get();

      if (!batchDoc.exists) {
        throw Exception('Batch delivery not found');
      }

      final batch = BatchDelivery.fromMap(batchDoc.data()!);
      final updatedBatch = batch.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      await batchRef.update(updatedBatch.toMap());
      _logger.info('Updated batch delivery status: ${batch.id} to $status');
      return updatedBatch;
    } catch (e) {
      _logger.severe('Error updating batch delivery status: $e');
      rethrow;
    }
  }

  Future<void> optimizeBatchRoute(String batchId) async {
    try {
      _logger.info('Optimizing route for batch $batchId');

      // Fetch batch details
      final batch = await getBatchDelivery(batchId);
      final deliveries = await Future.wait(batch.deliveryIds.map((id) => _getDelivery(id)));

      // Prepare waypoints for the API call
      final waypoints =
          deliveries.map((delivery) => '${delivery.pickup.latitude},${delivery.pickup.longitude}').toList();
      final origin = waypoints.first;
      final destination = waypoints.last;

      // Call Google Maps Directions API
      final apiKey = 'YOUR_API_KEY'; // TODO Replace with your actual API key
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=optimize:true|${waypoints.join('|')}&key=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final optimizedWaypoints = route['waypoint_order'] as List;
          final optimizedDeliveryIds = optimizedWaypoints.map((index) => batch.deliveryIds[index]).toList();

          // Update batch with optimized route
          await _firestore.collection('batch_deliveries').doc(batchId).update({
            'routeOptimized': true,
            'optimizedDeliveryIds': optimizedDeliveryIds,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          _logger.info('Route optimized successfully');
        } else {
          throw Exception('Failed to optimize route: ${data['status']}');
        }
      } else {
        throw Exception('Failed to call Google Maps API: ${response.statusCode}');
      }
    } catch (e) {
      _logger.severe('Error optimizing route: $e');
      rethrow;
    }
  }

  Stream<List<BatchDelivery>> getDriverBatches(String driverId) {
    return _firestore
        .collection('batch_deliveries')
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => BatchDelivery.fromMap(doc.data())).toList());
  }

  Future<BatchDelivery> getBatchDelivery(String batchId) async {
    try {
      final batchDoc = await _firestore.collection('batch_deliveries').doc(batchId).get();

      if (!batchDoc.exists) {
        throw Exception('Batch delivery not found');
      }

      return BatchDelivery.fromMap(batchDoc.data()!);
    } catch (e) {
      _logger.severe('Error getting batch delivery: $e');
      rethrow;
    }
  }

  Future<BatchDelivery> cancelBatch(String batchId) async {
    try {
      final batchRef = _firestore.collection('batch_deliveries').doc(batchId);
      final batchDoc = await batchRef.get();

      if (!batchDoc.exists) {
        throw Exception('Batch delivery not found');
      }

      final batch = BatchDelivery.fromMap(batchDoc.data()!);
      final updatedBatch = batch.copyWith(
        status: 'cancelled',
        updatedAt: DateTime.now(),
      );

      await batchRef.update(updatedBatch.toMap());
      _logger.info('Cancelled batch delivery: ${batch.id}');
      return updatedBatch;
    } catch (e) {
      _logger.severe('Error cancelling batch delivery: $e');
      rethrow;
    }
  }

  Future<BatchDeliveryDetails> getBatchDeliveryDetails(String batchId) async {
    try {
      _logger.info('Getting batch delivery details for $batchId');

      final batch = await getBatchDelivery(batchId);

      final deliveries = await Future.wait(
        batch.deliveryIds.map((id) => _getDelivery(id)),
      );

      // Calculate route using Google Maps Directions API
      final waypoints =
          deliveries.map((delivery) => '${delivery.pickup.latitude},${delivery.pickup.longitude}').toList();
      final origin = waypoints.first;
      final destination = waypoints.last;

      final apiKey = 'YOUR_API_KEY'; // TODO Replace with your actual API key
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=${waypoints.join('|')}&key=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final legs = (route['legs'] as List).cast<Map<String, dynamic>>();
          final totalDistance =
              legs.fold<double>(0, (total, leg) => total + (leg['distance']['value'] as num).toDouble());
          final estimatedDuration =
              legs.fold<int>(0, (total, leg) => total + (leg['duration']['value'] as num).toInt());

          return BatchDeliveryDetails(
            batchId: batchId,
            deliveries: deliveries,
            route: legs,
            totalDistance: totalDistance,
            estimatedDuration: estimatedDuration,
          );
        }
      }
      throw Exception('Failed to calculate route');
    } catch (e) {
      _logger.severe('Error getting batch delivery details: $e');
      rethrow;
    }
  }

  Future<Delivery> _getDelivery(String deliveryId) async {
    final doc = await _firestore.collection('deliveries').doc(deliveryId).get();
    if (!doc.exists) {
      throw Exception('Delivery not found');
    }
    return Delivery.fromMap(doc.data()!);
  }
}
