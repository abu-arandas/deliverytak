import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';
import 'product.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final String shippingAddress;
  final String paymentMethod;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
    this.trackingNumber,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: (map['items'] as List)
          .map((item) => CartItem(
                id: item['id'],
                product: Product.fromMap(item['product'] as Map<String, dynamic>),
                quantity: item['quantity'] as int,
              ))
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      status: map['status'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      shippingAddress: map['shippingAddress'] as String,
      paymentMethod: map['paymentMethod'] as String,
      trackingNumber: map['trackingNumber'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items
          .map((item) => {
                'product': item.product.toMap(),
                'quantity': item.quantity,
              })
          .toList(),
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'trackingNumber': trackingNumber,
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? totalAmount,
    String? status,
    DateTime? createdAt,
    String? shippingAddress,
    String? paymentMethod,
    String? trackingNumber,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }
}
