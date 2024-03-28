import '/exports.dart';

class BrandModel {
  String id, name;

  BrandModel({required this.id, required this.name});

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      BrandModel(id: json['id'], name: json['content']['title']);

  factory BrandModel.fromDoc(DocumentSnapshot json) =>
      BrandModel(id: json.id, name: json['content']['title']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
