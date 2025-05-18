import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/delivery.dart';
import '../services/delivery_service.dart';

class DeliveryProvider with ChangeNotifier {
  final DeliveryService _deliveryService;
  bool _isLoading = false;
  String? _error;
  Delivery? _currentDelivery;
  List<Delivery> _userDeliveries = [];
  List<Delivery> _driverDeliveries = [];

  DeliveryProvider(this._deliveryService);

  bool get isLoading => _isLoading;
  String? get error => _error;
  Delivery? get currentDelivery => _currentDelivery;
  List<Delivery> get userDeliveries => _userDeliveries;
  List<Delivery> get driverDeliveries => _driverDeliveries;

  Future<void> createDelivery({
    required String orderId,
    required String userId,
    required String driverId,
    String? estimatedDeliveryTime,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentDelivery = await _deliveryService.createDelivery(
        orderId: orderId,
        userId: userId,
        driverId: driverId,
        estimatedDeliveryTime: estimatedDeliveryTime,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateDeliveryStatus({
    required String deliveryId,
    required DeliveryStatus status,
    required String message,
    GeoPoint? location,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _deliveryService.updateDeliveryStatus(
        deliveryId: deliveryId,
        status: status,
        message: message,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateDeliveryLocation({
    required String deliveryId,
    required GeoPoint location,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _deliveryService.updateDeliveryLocation(
        deliveryId: deliveryId,
        location: location,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> markDeliveryAsDelivered({
    required String deliveryId,
    required String actualDeliveryTime,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _deliveryService.markDeliveryAsDelivered(
        deliveryId: deliveryId,
        actualDeliveryTime: actualDeliveryTime,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> markDeliveryAsFailed({
    required String deliveryId,
    required String failureReason,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _deliveryService.markDeliveryAsFailed(
        deliveryId: deliveryId,
        failureReason: failureReason,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void startDeliveryTracking(String deliveryId) {
    _deliveryService.getDeliveryStream(deliveryId).listen(
      (delivery) {
        _currentDelivery = delivery;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  void startUserDeliveriesTracking(String userId) {
    _deliveryService.getDeliveriesByUserId(userId).listen(
      (deliveries) {
        _userDeliveries = deliveries;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  void startDriverDeliveriesTracking(String driverId) {
    _deliveryService.getDeliveriesByDriverId(driverId).listen(
      (deliveries) {
        _driverDeliveries = deliveries;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
