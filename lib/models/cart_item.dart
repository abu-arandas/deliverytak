import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  // Add operator [] to support map-like access
  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'name':
        return product.name;
      case 'price':
        return product.price;
      case 'imageUrl':
        return product.imageUrl;
      case 'quantity':
        return quantity;
      default:
        return null;
    }
  }

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
