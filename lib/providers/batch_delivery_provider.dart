import 'package:flutter/foundation.dart';
import '../models/batch_delivery.dart';
import '../models/batch_delivery_details.dart';
import '../services/batch_delivery_service.dart';

class BatchDeliveryProvider extends ChangeNotifier {
  final BatchDeliveryService _service;
  bool _isLoading = false;
  String? _error;
  List<BatchDelivery> _batchDeliveries = [];
  BatchDelivery? _currentBatch;
  BatchDeliveryDetails? _currentBatchDetails;

  BatchDeliveryProvider(this._service);

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<BatchDelivery> get batchDeliveries => _batchDeliveries;
  BatchDelivery? get currentBatch => _currentBatch;
  BatchDeliveryDetails? get currentBatchDetails => _currentBatchDetails;

  Future<void> createBatchDelivery({
    required String driverId,
    required List<String> deliveryIds,
    String? notes,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.createBatchDelivery(
        driverId: driverId,
        deliveryIds: deliveryIds,
        notes: notes,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBatchStatus({
    required String batchId,
    required String status,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.updateBatchStatus(
        batchId: batchId,
        status: status,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> optimizeBatchRoute(String batchId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.optimizeBatchRoute(batchId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startBatchTracking(String driverId) {
    _service.getDriverBatches(driverId).listen(
      (batchDeliveries) {
        _batchDeliveries = batchDeliveries;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> loadBatchDelivery(String batchId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final batch = await _service.getBatchDelivery(batchId);
      final details = await _service.getBatchDeliveryDetails(batchId);

      _currentBatch = batch;
      _currentBatchDetails = details;
    } catch (e) {
      _error = e.toString();
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
