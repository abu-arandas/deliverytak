class CartModel {
  String id;
  int color, size, stock;

  CartModel({
    required this.id,
    required this.color,
    required this.size,
    required this.stock,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json['id'],
        color: json['color'],
        size: json['size'],
        stock: json['stock'],
      );

  CartModel copyWith({
    int? color,
    int? size,
    int? stock,
  }) =>
      CartModel(
        id: id,
        color: color ?? this.color,
        size: size ?? this.size,
        stock: stock ?? this.stock,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color,
        'size': size,
        'stock': stock,
      };
}
