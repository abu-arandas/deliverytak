import 'package:cloud_firestore/cloud_firestore.dart';

class BatchDelivery {
  final String id;
  final String driverId;
  final List<String> deliveryIds;
  final String status; // 'pending', 'in_progress', 'completed', 'cancelled'
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? totalDistance;
  final int? estimatedDuration;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final List<Map<String, dynamic>>? optimizedRoute;

  BatchDelivery({
    required this.id,
    required this.driverId,
    required this.deliveryIds,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.totalDistance,
    this.estimatedDuration,
    this.startedAt,
    this.completedAt,
    this.optimizedRoute,
  });

  factory BatchDelivery.fromMap(Map<String, dynamic> map) {
    return BatchDelivery(
      id: map['id'] as String,
      driverId: map['driverId'] as String,
      deliveryIds: List<String>.from(map['deliveryIds'] as List),
      status: map['status'] as String,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      totalDistance: map['totalDistance'] as double?,
      estimatedDuration: map['estimatedDuration'] as int?,
      startedAt: map['startedAt'] != null ? (map['startedAt'] as Timestamp).toDate() : null,
      completedAt: map['completedAt'] != null ? (map['completedAt'] as Timestamp).toDate() : null,
      optimizedRoute:
          map['optimizedRoute'] != null ? List<Map<String, dynamic>>.from(map['optimizedRoute'] as List) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driverId': driverId,
      'deliveryIds': deliveryIds,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'totalDistance': totalDistance,
      'estimatedDuration': estimatedDuration,
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'optimizedRoute': optimizedRoute,
    };
  }

  BatchDelivery copyWith({
    String? id,
    String? driverId,
    List<String>? deliveryIds,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? totalDistance,
    int? estimatedDuration,
    DateTime? startedAt,
    DateTime? completedAt,
    List<Map<String, dynamic>>? optimizedRoute,
  }) {
    return BatchDelivery(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      deliveryIds: deliveryIds ?? this.deliveryIds,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalDistance: totalDistance ?? this.totalDistance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      optimizedRoute: optimizedRoute ?? this.optimizedRoute,
    );
  }
}
