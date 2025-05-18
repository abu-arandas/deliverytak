import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class WishlistItem {
  final String id;
  final String userId;
  final Product product;
  final DateTime addedAt;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.product,
    required this.addedAt,
  });

  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      id: map['id'] as String,
      userId: map['userId'] as String,
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'product': product.toMap(),
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
