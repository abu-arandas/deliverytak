import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/delivery_rating.dart';

class RatingService {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  RatingService({
    required FirebaseFirestore firestore,
    Logger? logger,
  })  : _firestore = firestore,
        _logger = logger ?? Logger();

  Future<DeliveryRating> createRating({
    required String deliveryId,
    required String userId,
    required String driverId,
    required int rating,
    String? comment,
  }) async {
    try {
      _logger.i('Creating rating for delivery $deliveryId');

      final ratingDoc = DeliveryRating(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        deliveryId: deliveryId,
        userId: userId,
        driverId: driverId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('ratings').doc(ratingDoc.id).set(ratingDoc.toMap());

      // Update driver's average rating
      await _updateDriverRating(driverId);

      _logger.i('Rating created successfully for delivery $deliveryId');
      return ratingDoc;
    } catch (e) {
      _logger.e('Error creating rating for delivery $deliveryId', error: e);
      rethrow;
    }
  }

  Future<void> _updateDriverRating(String driverId) async {
    try {
      final ratingsSnapshot = await _firestore.collection('ratings').where('driverId', isEqualTo: driverId).get();

      if (ratingsSnapshot.docs.isEmpty) return;

      final ratings = ratingsSnapshot.docs.map((doc) => DeliveryRating.fromMap(doc.data())).toList();

      final averageRating = ratings.fold<double>(
            0,
            (total, rating) => total + rating.rating,
          ) /
          ratings.length;

      await _firestore.collection('drivers').doc(driverId).update({
        'averageRating': averageRating,
        'totalRatings': ratings.length,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Driver rating updated successfully for driver $driverId');
    } catch (e) {
      _logger.e('Error updating driver rating for driver $driverId', error: e);
      rethrow;
    }
  }

  Stream<List<DeliveryRating>> getDeliveryRatings(String deliveryId) {
    return _firestore
        .collection('ratings')
        .where('deliveryId', isEqualTo: deliveryId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => DeliveryRating.fromMap(doc.data())).toList());
  }

  Stream<List<DeliveryRating>> getDriverRatings(String driverId) {
    return _firestore
        .collection('ratings')
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => DeliveryRating.fromMap(doc.data())).toList());
  }

  Future<double> getDriverAverageRating(String driverId) async {
    try {
      final driverDoc = await _firestore.collection('drivers').doc(driverId).get();
      if (!driverDoc.exists) return 0.0;

      final data = driverDoc.data();
      return (data?['averageRating'] as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      _logger.e('Error getting driver average rating for driver $driverId', error: e);
      return 0.0;
    }
  }
}
