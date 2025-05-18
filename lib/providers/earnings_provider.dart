import 'package:flutter/foundation.dart';
import '../models/driver_earnings.dart';
import '../services/earnings_service.dart';

class EarningsProvider with ChangeNotifier {
  final EarningsService _earningsService;
  bool _isLoading = false;
  String? _error;
  List<DriverEarnings> _earnings = [];
  Map<String, dynamic>? _earningsSummary;
  List<Map<String, dynamic>> _periodEarnings = [];

  EarningsProvider(this._earningsService);

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DriverEarnings> get earnings => _earnings;
  Map<String, dynamic>? get earningsSummary => _earningsSummary;
  List<Map<String, dynamic>> get periodEarnings => _periodEarnings;

  Future<void> createEarning({
    required String driverId,
    required double amount,
    required String deliveryId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _earningsService.createEarning(
        driverId: driverId,
        amount: amount,
        deliveryId: deliveryId,
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

  Future<void> updateEarningStatus({
    required String earningId,
    required String status,
    String? paymentMethod,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _earningsService.updateEarningStatus(
        earningId: earningId,
        status: status,
        paymentMethod: paymentMethod,
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

  void startEarningsTracking(String driverId) {
    _earningsService.getDriverEarnings(driverId).listen(
      (earnings) {
        _earnings = earnings;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<void> loadEarningsSummary(String driverId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _earningsSummary = await _earningsService.getDriverEarningsSummary(driverId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadEarningsByPeriod(
    String driverId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _periodEarnings = await _earningsService.getDriverEarningsByPeriod(
        driverId,
        startDate,
        endDate,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
