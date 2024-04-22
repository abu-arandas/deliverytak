import '/exports.dart';

class ProductModel {
  String id, name, image;
  double price;
  String category, description;
  List<String> sizes;
  List<String> images;
  String? brand;
  Genders gender;
  int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    required this.sizes,
    required this.images,
    this.brand,
    required this.gender,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        price: double.parse(
          (double.parse(
            json['price'].toString(),
          )).toStringAsFixed(2),
        ),
        category: json['category'],
        description: json['description'],
        sizes: List.generate(
          json['sizes'].length,
          (index) => json['sizes'][index].toString(),
        ),
        images: List.generate(
          json['images'].length,
          (index) => json['images'][index].toString(),
        ),
        brand: json['brand'],
        gender: genders.map[json['gender']]!,
        stock: json['stock'],
      );

  factory ProductModel.fromDoc(DocumentSnapshot json) => ProductModel(
        id: json.id,
        name: json['name'],
        image: json['image'],
        price: double.parse(
          (double.parse(
            json['price'].toString(),
          )).toStringAsFixed(2),
        ),
        category: json['category'],
        description: json['description'],
        sizes: List.generate(
          json['sizes'].length,
          (index) => json['sizes'][index].toString(),
        ),
        images: List.generate(
          json['images'].length,
          (index) => json['images'][index].toString(),
        ),
        brand: json['brand'],
        gender: genders.map[json['gender']]!,
        stock: json['stock'],
      );

  ProductModel copyWith({
    String? name,
    String? image,
    double? price,
    String? category,
    String? description,
    List<String>? sizes,
    List<String>? images,
    String? brand,
    Genders? gender,
    int? stock,
  }) =>
      ProductModel(
        id: id,
        name: name ?? this.name,
        image: image ?? this.image,
        price: price ?? this.price,
        category: category ?? this.category,
        description: description ?? this.description,
        sizes: sizes ?? this.sizes,
        images: images ?? this.images,
        brand: brand ?? this.brand,
        gender: gender ?? this.gender,
        stock: stock ?? this.stock,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'price': price,
        'category': category,
        'description': description,
        'sizes': List.generate(
          sizes.length,
          (index) => sizes[index].toString(),
        ),
        'images': images,
        'brand': brand,
        'gender': genders.reverse[gender],
        'stock': stock,
      };
}
