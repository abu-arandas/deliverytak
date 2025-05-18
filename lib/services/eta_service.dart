import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ETAService {
  final FirebaseFirestore _firestore;
  final Logger _logger;
  final String _googleMapsApiKey;

  ETAService({
    required FirebaseFirestore firestore,
    required String googleMapsApiKey,
    Logger? logger,
  })  : _firestore = firestore,
        _googleMapsApiKey = googleMapsApiKey,
        _logger = logger ?? Logger();

  Future<Duration> calculateETA({
    required GeoPoint origin,
    required GeoPoint destination,
    String? mode = 'driving',
  }) async {
    try {
      _logger.i('Calculating ETA from $origin to $destination');

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=$mode'
        '&key=$_googleMapsApiKey',
      );

      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to get directions: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      if (data['status'] != 'OK') {
        throw Exception('Directions API error: ${data['status']}');
      }

      final routes = data['routes'] as List;
      if (routes.isEmpty) {
        throw Exception('No routes found');
      }

      final legs = routes[0]['legs'] as List;
      if (legs.isEmpty) {
        throw Exception('No legs found in route');
      }

      final durationInSeconds = legs[0]['duration']['value'] as int;
      final duration = Duration(seconds: durationInSeconds);

      _logger.i('ETA calculated: $duration');
      return duration;
    } catch (e) {
      _logger.e('Error calculating ETA', error: e);
      rethrow;
    }
  }

  String formatETA(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  Future<DateTime> calculateEstimatedArrivalTime({
    required GeoPoint origin,
    required GeoPoint destination,
    String? mode = 'driving',
  }) async {
    try {
      final eta = await calculateETA(
        origin: origin,
        destination: destination,
        mode: mode,
      );

      final estimatedArrival = DateTime.now().add(eta);
      _logger.i('Estimated arrival time: $estimatedArrival');
      return estimatedArrival;
    } catch (e) {
      _logger.e('Error calculating estimated arrival time', error: e);
      rethrow;
    }
  }

  Future<void> updateDeliveryETA({
    required String deliveryId,
    required GeoPoint currentLocation,
    required GeoPoint destination,
  }) async {
    try {
      _logger.i('Updating ETA for delivery $deliveryId');

      final estimatedArrival = await calculateEstimatedArrivalTime(
        origin: currentLocation,
        destination: destination,
      );

      await _firestore.collection('deliveries').doc(deliveryId).update({
        'estimatedDeliveryTime': estimatedArrival.toIso8601String(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('ETA updated successfully for delivery $deliveryId');
    } catch (e) {
      _logger.e('Error updating delivery ETA', error: e);
      rethrow;
    }
  }
}
