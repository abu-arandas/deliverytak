import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import '../services/route_optimization_service.dart';

class RouteOptimizationProvider extends ChangeNotifier {
  final RouteOptimizationService _service;
  final Logger _logger;

  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>>? _optimizedRoute;

  RouteOptimizationProvider({
    required RouteOptimizationService service,
    Logger? logger,
  })  : _service = service,
        _logger = logger ?? Logger('RouteOptimizationProvider');

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>>? get optimizedRoute => _optimizedRoute;

  Future<void> optimizeRoute({
    required List<GeoPoint> waypoints,
    required GeoPoint origin,
    required GeoPoint destination,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Starting route optimization');
      _optimizedRoute = await _service.optimizeRoute(
        waypoints: waypoints,
        origin: origin,
        destination: destination,
      );

      _logger.info('Route optimization completed successfully');
    } catch (e) {
      _error = e.toString();
      _logger.severe('Error optimizing route: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDeliveryRoute({
    required String deliveryId,
    required List<Map<String, dynamic>> optimizedRoute,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Updating delivery route for delivery $deliveryId');
      await _service.updateDeliveryRoute(
        deliveryId: deliveryId,
        optimizedRoute: optimizedRoute,
      );

      _logger.info('Delivery route updated successfully');
    } catch (e) {
      _error = e.toString();
      _logger.severe('Error updating delivery route: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
