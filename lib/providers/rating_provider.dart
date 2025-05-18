import 'package:flutter/foundation.dart';
import '../models/delivery_rating.dart';
import '../services/rating_service.dart';

class RatingProvider with ChangeNotifier {
  final RatingService _ratingService;
  bool _isLoading = false;
  String? _error;
  List<DeliveryRating> _deliveryRatings = [];
  List<DeliveryRating> _driverRatings = [];
  double _driverAverageRating = 0.0;

  RatingProvider(this._ratingService);

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DeliveryRating> get deliveryRatings => _deliveryRatings;
  List<DeliveryRating> get driverRatings => _driverRatings;
  double get driverAverageRating => _driverAverageRating;

  Future<void> createRating({
    required String deliveryId,
    required String userId,
    required String driverId,
    required int rating,
    String? comment,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _ratingService.createRating(
        deliveryId: deliveryId,
        userId: userId,
        driverId: driverId,
        rating: rating,
        comment: comment,
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

  void startDeliveryRatingsTracking(String deliveryId) {
    _ratingService.getDeliveryRatings(deliveryId).listen(
      (ratings) {
        _deliveryRatings = ratings;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  void startDriverRatingsTracking(String driverId) {
    _ratingService.getDriverRatings(driverId).listen(
      (ratings) {
        _driverRatings = ratings;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );

    _updateDriverAverageRating(driverId);
  }

  Future<void> _updateDriverAverageRating(String driverId) async {
    try {
      _driverAverageRating = await _ratingService.getDriverAverageRating(driverId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 