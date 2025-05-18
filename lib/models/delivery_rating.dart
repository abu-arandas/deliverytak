import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryRating {
  final String id;
  final String deliveryId;
  final String userId;
  final String driverId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  DeliveryRating({
    required this.id,
    required this.deliveryId,
    required this.userId,
    required this.driverId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory DeliveryRating.fromMap(Map<String, dynamic> map) {
    return DeliveryRating(
      id: map['id'] as String,
      deliveryId: map['deliveryId'] as String,
      userId: map['userId'] as String,
      driverId: map['driverId'] as String,
      rating: map['rating'] as int,
      comment: map['comment'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deliveryId': deliveryId,
      'userId': userId,
      'driverId': driverId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  DeliveryRating copyWith({
    String? id,
    String? deliveryId,
    String? userId,
    String? driverId,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return DeliveryRating(
      id: id ?? this.id,
      deliveryId: deliveryId ?? this.deliveryId,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
