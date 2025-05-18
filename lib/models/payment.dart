import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final String status;
  final String paymentMethod;
  final Map<String, dynamic> paymentDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.paymentDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as String,
      orderId: map['orderId'] as String,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      status: map['status'] as String,
      paymentMethod: map['paymentMethod'] as String,
      paymentDetails: Map<String, dynamic>.from(map['paymentDetails'] as Map),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentDetails': paymentDetails,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Payment copyWith({
    String? id,
    String? orderId,
    double? amount,
    String? currency,
    String? status,
    String? paymentMethod,
    Map<String, dynamic>? paymentDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
