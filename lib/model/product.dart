import '/exports.dart';

class ProductModel {
  String id, name;
  double price;
  String description;
  List<String> images;
  List<String> sizes;
  List<Color> colors;
  String? category, brand;
  Genders? gender;
  int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.category,
    required this.description,
    required this.images,
    required this.sizes,
    required this.colors,
    this.brand,
    this.gender,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        price: double.parse(
          json['price'].toStringAsFixed(2),
        ),
        category: json['category'],
        description: json['description'],
        images: List.generate(
          json['images'].length,
          (index) => json['images'][index].toString(),
        ),
        sizes: List.generate(
          json['sizes'].length,
          (index) => json['sizes'][index].toString(),
        ),
        colors: List.generate(
          json['colors'].length,
          (index) => Color(json['colors'][index]),
        ),
        brand: json['brand'],
        gender: json['gender'] != null ? genders.map[json['gender']]! : null,
        stock: json['stock'],
      );

  factory ProductModel.fromDoc(DocumentSnapshot json) => ProductModel(
        id: json.id,
        name: json['name'],
        price: double.parse(
          json['price'].toStringAsFixed(2),
        ),
        category: json['category'],
        description: json['description'],
        images: List.generate(
          json['images'].length,
          (index) => json['images'][index].toString(),
        ),
        sizes: List.generate(
          json['sizes'].length,
          (index) => json['sizes'][index].toString(),
        ),
        colors: List.generate(
          json['colors'].length,
          (index) => Color(json['colors'][index]),
        ),
        brand: json['brand'],
        gender: json['gender'] != null ? genders.map[json['gender']]! : null,
        stock: json['stock'],
      );

  ProductModel copyWith({
    String? name,
    double? price,
    String? category,
    String? description,
    List<String>? images,
    List<String>? sizes,
    List<Color>? colors,
    String? brand,
    Genders? gender,
    int? stock,
  }) =>
      ProductModel(
        id: id,
        name: name ?? this.name,
        price: price ?? this.price,
        category: category ?? this.category,
        description: description ?? this.description,
        images: images ?? this.images,
        sizes: sizes ?? this.sizes,
        colors: colors ?? this.colors,
        brand: brand ?? this.brand,
        gender: gender ?? this.gender,
        stock: stock ?? this.stock,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'category': category,
        'description': description,
        'images': images,
        'sizes': List.generate(
          sizes.length,
          (index) => sizes[index].toString(),
        ),
        'colors': colors.map((e) => e.value).toList(),
        'brand': brand,
        'gender': gender != null ? genders.reverse[gender] : null,
        'stock': stock,
      };
}
