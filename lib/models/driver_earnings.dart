import 'package:cloud_firestore/cloud_firestore.dart';

class DriverEarnings {
  final String id;
  final String driverId;
  final double amount;
  final String deliveryId;
  final DateTime date;
  final String status; // 'pending', 'completed', 'cancelled'
  final String? paymentMethod;
  final DateTime? paidAt;

  DriverEarnings({
    required this.id,
    required this.driverId,
    required this.amount,
    required this.deliveryId,
    required this.date,
    required this.status,
    this.paymentMethod,
    this.paidAt,
  });

  factory DriverEarnings.fromMap(Map<String, dynamic> map) {
    return DriverEarnings(
      id: map['id'] as String,
      driverId: map['driverId'] as String,
      amount: (map['amount'] as num).toDouble(),
      deliveryId: map['deliveryId'] as String,
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'] as String,
      paymentMethod: map['paymentMethod'] as String?,
      paidAt: map['paidAt'] != null ? (map['paidAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driverId': driverId,
      'amount': amount,
      'deliveryId': deliveryId,
      'date': Timestamp.fromDate(date),
      'status': status,
      'paymentMethod': paymentMethod,
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
    };
  }

  DriverEarnings copyWith({
    String? id,
    String? driverId,
    double? amount,
    String? deliveryId,
    DateTime? date,
    String? status,
    String? paymentMethod,
    DateTime? paidAt,
  }) {
    return DriverEarnings(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      amount: amount ?? this.amount,
      deliveryId: deliveryId ?? this.deliveryId,
      date: date ?? this.date,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
