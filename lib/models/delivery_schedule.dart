import 'package:cloud_firestore/cloud_firestore.dart';

class DeliverySchedule {
  final String id;
  final String deliveryId;
  final String driverId;
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final String status; // 'scheduled', 'in_progress', 'completed', 'cancelled'
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DeliverySchedule({
    required this.id,
    required this.deliveryId,
    required this.driverId,
    required this.scheduledTime,
    this.actualTime,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory DeliverySchedule.fromMap(Map<String, dynamic> map) {
    return DeliverySchedule(
      id: map['id'] as String,
      deliveryId: map['deliveryId'] as String,
      driverId: map['driverId'] as String,
      scheduledTime: (map['scheduledTime'] as Timestamp).toDate(),
      actualTime: map['actualTime'] != null ? (map['actualTime'] as Timestamp).toDate() : null,
      status: map['status'] as String,
      notes: map['notes'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deliveryId': deliveryId,
      'driverId': driverId,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'actualTime': actualTime != null ? Timestamp.fromDate(actualTime!) : null,
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  DeliverySchedule copyWith({
    String? id,
    String? deliveryId,
    String? driverId,
    DateTime? scheduledTime,
    DateTime? actualTime,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliverySchedule(
      id: id ?? this.id,
      deliveryId: deliveryId ?? this.deliveryId,
      driverId: driverId ?? this.driverId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      actualTime: actualTime ?? this.actualTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
