import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../services/driver_service.dart';

class DriverProvider extends ChangeNotifier {
  final DriverService _service;
  final Logger _logger;

  bool _isLoading = false;
  String? _error;
  DocumentSnapshot? _currentDriver;
  List<DocumentSnapshot> _availableDrivers = [];
  List<DocumentSnapshot> _driversByStatus = [];

  DriverProvider(
    this._service, [
    Logger? logger,
  ]) : _logger = logger ?? Logger('DriverProvider');

  bool get isLoading => _isLoading;
  String? get error => _error;
  DocumentSnapshot? get currentDriver => _currentDriver;
  List<DocumentSnapshot> get availableDrivers => _availableDrivers;
  List<DocumentSnapshot> get driversByStatus => _driversByStatus;

  Future<void> updateDriverStatus({
    required String driverId,
    required String status,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Updating driver status: $driverId');

      await _service.updateDriverStatus(
        driverId: driverId,
        status: status,
      );

      _logger.info('Driver status updated successfully');
    } catch (e) {
      _error = 'Failed to update driver status: $e';
      _logger.severe('Error updating driver status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDriverLocation({
    required String driverId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Updating driver location: $driverId');

      await _service.updateDriverLocation(
        driverId: driverId,
        latitude: latitude,
        longitude: longitude,
      );

      _logger.info('Driver location updated successfully');
    } catch (e) {
      _error = 'Failed to update driver location: $e';
      _logger.severe('Error updating driver location: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDriverProfile({
    required String driverId,
    required Map<String, dynamic> data,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Updating driver profile: $driverId');

      await _service.updateDriverProfile(
        driverId: driverId,
        data: data,
      );

      _logger.info('Driver profile updated successfully');
    } catch (e) {
      _error = 'Failed to update driver profile: $e';
      _logger.severe('Error updating driver profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startDriverTracking(String driverId) {
    _logger.info('Starting driver tracking: $driverId');

    _service.getDriverStream(driverId).listen(
      (doc) {
        _currentDriver = doc;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to track driver: $e';
        _logger.severe('Error tracking driver: $e');
        notifyListeners();
      },
    );
  }

  Future<void> loadDriver(String driverId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Loading driver: $driverId');

      _currentDriver = await _service.getDriver(driverId);

      _logger.info('Driver loaded successfully');
    } catch (e) {
      _error = 'Failed to load driver: $e';
      _logger.severe('Error loading driver: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAvailableDrivers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Loading available drivers');

      _availableDrivers = await _service.getAvailableDrivers();

      _logger.info('Available drivers loaded successfully');
    } catch (e) {
      _error = 'Failed to load available drivers: $e';
      _logger.severe('Error loading available drivers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDriversByStatus(String status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logger.info('Loading drivers by status: $status');

      _driversByStatus = await _service.getDriversByStatus(status);

      _logger.info('Drivers by status loaded successfully');
    } catch (e) {
      _error = 'Failed to load drivers by status: $e';
      _logger.severe('Error loading drivers by status: $e');
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
