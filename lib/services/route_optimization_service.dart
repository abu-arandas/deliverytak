import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteOptimizationService {
  final FirebaseFirestore _firestore;
  final Logger _logger;
  final String _googleMapsApiKey;

  RouteOptimizationService({
    required FirebaseFirestore firestore,
    required String googleMapsApiKey,
    Logger? logger,
  })  : _firestore = firestore,
        _googleMapsApiKey = googleMapsApiKey,
        _logger = logger ?? Logger('RouteOptimizationService');

  Future<List<Map<String, dynamic>>> optimizeRoute({
    required List<GeoPoint> waypoints,
    required GeoPoint origin,
    required GeoPoint destination,
  }) async {
    try {
      _logger.info('Optimizing route with ${waypoints.length} waypoints');

      // Create a list of all points including origin and destination
      final allPoints = [origin, ...waypoints, destination];

      // Calculate the distance matrix
      final distanceMatrix = await _calculateDistanceMatrix(allPoints);

      // Find the optimal route using the nearest neighbor algorithm
      final optimizedRoute = _findOptimalRoute(distanceMatrix, allPoints);

      // Get detailed directions for the optimized route
      final directions = await _getDetailedDirections(optimizedRoute, allPoints);

      _logger.info('Route optimization completed successfully');
      return directions;
    } catch (e) {
      _logger.severe('Error optimizing route: $e');
      rethrow;
    }
  }

  Future<List<List<double>>> _calculateDistanceMatrix(List<GeoPoint> points) async {
    try {
      final origins = points.map((p) => '${p.latitude},${p.longitude}').join('|');
      final destinations = origins;

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json'
        '?origins=$origins'
        '&destinations=$destinations'
        '&key=$_googleMapsApiKey',
      );

      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to get distance matrix: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      if (data['status'] != 'OK') {
        throw Exception('Distance Matrix API error: ${data['status']}');
      }

      final rows = data['rows'] as List;
      return rows.map((row) {
        final elements = row['elements'] as List;
        return elements.map((element) {
          return (element['distance']['value'] as num).toDouble();
        }).toList();
      }).toList();
    } catch (e) {
      _logger.severe('Error calculating distance matrix: $e');
      rethrow;
    }
  }

  List<int> _findOptimalRoute(List<List<double>> distanceMatrix, List<GeoPoint> points) {
    final n = points.length;
    final visited = List<bool>.filled(n, false);
    final route = <int>[];
    var current = 0; // Start from origin
    visited[current] = true;
    route.add(current);

    while (route.length < n) {
      var next = -1;
      var minDistance = double.infinity;

      for (var i = 0; i < n; i++) {
        if (!visited[i] && distanceMatrix[current][i] < minDistance) {
          minDistance = distanceMatrix[current][i];
          next = i;
        }
      }

      if (next == -1) break;
      visited[next] = true;
      route.add(next);
      current = next;
    }

    return route;
  }

  Future<List<Map<String, dynamic>>> _getDetailedDirections(
    List<int> route,
    List<GeoPoint> points,
  ) async {
    try {
      final directions = <Map<String, dynamic>>[];
      for (var i = 0; i < route.length - 1; i++) {
        final originIndex = route[i];
        final destinationIndex = route[i + 1];
        final originPoint = points[originIndex];
        final destinationPoint = points[destinationIndex];

        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${originPoint.latitude},${originPoint.longitude}'
          '&destination=${destinationPoint.latitude},${destinationPoint.longitude}'
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

        directions.add({
          'origin': originPoint,
          'destination': destinationPoint,
          'distance': legs[0]['distance']['value'],
          'duration': legs[0]['duration']['value'],
          'steps': legs[0]['steps'],
        });
      }

      return directions;
    } catch (e) {
      _logger.severe('Error getting detailed directions: $e');
      rethrow;
    }
  }

  Future<void> updateDeliveryRoute({
    required String deliveryId,
    required List<Map<String, dynamic>> optimizedRoute,
  }) async {
    try {
      _logger.info('Updating delivery route for delivery $deliveryId');

      await _firestore.collection('deliveries').doc(deliveryId).update({
        'optimizedRoute': optimizedRoute,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.info('Delivery route updated successfully for delivery $deliveryId');
    } catch (e) {
      _logger.severe('Error updating delivery route for delivery $deliveryId: $e');
      rethrow;
    }
  }
}
