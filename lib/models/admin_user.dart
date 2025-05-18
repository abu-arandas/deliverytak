import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUser {
  final String id;
  final String email;
  final String name;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminUser({
    required this.id,
    required this.email,
    required this.name,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminUser.fromMap(Map<String, dynamic> map) {
    return AdminUser(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      roles: List<String>.from(map['roles'] as List),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'roles': roles,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  AdminUser copyWith({
    String? id,
    String? email,
    String? name,
    List<String>? roles,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      roles: roles ?? this.roles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool hasRole(String role) {
    return roles.contains(role);
  }
}
