import '/exports.dart';

class UserModel {
  String id;
  Map name;
  String email;
  String? password;
  String image;
  PhoneNumber phone;
  GeoPoint? address;
  UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.image,
    required this.phone,
    this.address,
    required this.role,
  });

  factory UserModel.fromJson(DocumentSnapshot data) => UserModel(
        id: data.id,
        name: {'first': data['name']['first'], 'last': data['name']['last']},
        email: data['email'],
        image: data['image'],
        password: data['password'],
        phone: PhoneNumber.fromJson(data['phone']),
        address: data['address'],
        role: roles.map[data['role']]!,
      );

  UserModel copyWith({
    Map? newName,
    String? newEmail,
    String? newPassword,
    String? newImage,
    PhoneNumber? newPhone,
    GeoPoint? newAddress,
  }) =>
      UserModel(
        id: id,
        name: newName ?? name,
        email: newEmail ?? email,
        password: newPassword ?? password,
        image: newImage ?? image,
        phone: newPhone ?? phone,
        address: newAddress ?? address,
        role: role,
      );

  Map<String, dynamic> toJson() => {
        'name': {'first': name['first'], 'last': name['last']},
        'email': email,
        'password': null,
        'image': image,
        'phone': phone.toJson(),
        'address': address,
        'role': roles.reverse[role],
      };
}

enum UserRole { admin, client }

EnumValues<UserRole> roles = EnumValues({
  'Admin': UserRole.admin,
  'Client': UserRole.client,
});
