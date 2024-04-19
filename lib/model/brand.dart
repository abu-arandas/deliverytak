import '/exports.dart';

class BrandModel {
  String id, name, image;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory BrandModel.fromDoc(DocumentSnapshot json) => BrandModel(
        id: json.id,
        name: json['name'],
        image: json['image'],
      );

  BrandModel copyWith({String? name, String? image}) => BrandModel(
        id: id,
        name: name ?? this.name,
        image: image ?? this.image,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
      };
}
