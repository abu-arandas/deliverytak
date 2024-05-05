import '/exports.dart';

class UserModel {
  String id;
  Map name;
  String email;
  String? password;
  String image;
  PhoneNumber phone;
  GeoPoint? address;
  bool available;
  UserRole role;
  String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.image,
    required this.phone,
    this.available = false,
    this.address,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(DocumentSnapshot data) => UserModel(
        id: data.id,
        name: {'first': data['name']['first'], 'last': data['name']['last']},
        email: data['email'],
        image: data['image'],
        password: data['password'],
        phone: PhoneNumber.fromJson(data['phone']),
        available: data['available'],
        address: data['address'],
        role: roles.map[data['role']]!,
        token: data['token'],
      );

  UserModel copyWith({
    Map? name,
    String? email,
    String? password,
    String? image,
    PhoneNumber? phone,
    GeoPoint? address,
    bool? available,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        image: image ?? this.image,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        available: available ?? this.available,
        role: role,
        token: token,
      );

  Map<String, dynamic> toJson() => {
        'name': {'first': name['first'], 'last': name['last']},
        'email': email,
        'password': null,
        'image': image,
        'phone': phone.toJson(),
        'address': address,
        'available': available,
        'role': roles.reverse[role],
        'token': token,
      };
}

enum UserRole { admin, client, driver }

EnumValues<UserRole> roles = EnumValues({
  'Admin': UserRole.admin,
  'Client': UserRole.client,
  'Driver': UserRole.driver,
});
