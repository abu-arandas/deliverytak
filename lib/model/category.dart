import '/exports.dart';

class CategoryModel {
  String id, name, image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromDoc(DocumentSnapshot json) => CategoryModel(
        id: json.id,
        name: json['name'],
        image: json['image'],
      );

  CategoryModel copyWith({String? name, String? image}) => CategoryModel(
        id: id,
        name: name ?? this.name,
        image: image ?? this.image,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
      };
}
