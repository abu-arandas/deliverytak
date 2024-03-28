import '/exports.dart';

class ProductModel {
  String id, name;
  double price;
  String brandName;
  String imageUrl;
  List<String> additionalImageUrls;
  int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.brandName,
    required this.imageUrl,
    required this.additionalImageUrls,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'].toString(),
        name: json['name'].toString(),
        price: double.parse(json['price'].toString()),
        brandName: json['brandName'].toString(),
        imageUrl: json['imageUrl'],
        additionalImageUrls: json['additionalImageUrls'] == null
            ? []
            : List<String>.from(json['additionalImageUrls']!.map((x) => x)),
        stock: json['stock'],
      );

  factory ProductModel.fromDoc(DocumentSnapshot json) => ProductModel(
        id: json.id,
        name: json['name'].toString(),
        price: double.parse(json['price'].toString()),
        brandName: json['brandName'].toString(),
        imageUrl: 'https://${json['imageUrl']}',
        additionalImageUrls: json['additionalImageUrls'] == null
            ? []
            : List<String>.from(
                json['additionalImageUrls']!.map((x) => 'https://$x')),
        stock: json['stock'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'brandName': brandName,
        'imageUrl': imageUrl,
        'additionalImageUrls': additionalImageUrls.map((x) => x).toList(),
        'stock': stock,
      };
}
