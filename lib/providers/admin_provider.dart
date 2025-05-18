import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_user.dart';

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AdminUser? _currentAdmin;
  List<AdminUser> _admins = [];
  bool _isLoading = false;
  String? _error;

  AdminUser? get currentAdmin => _currentAdmin;
  List<AdminUser> get admins => _admins;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllAdmins() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestore.collection('admins').orderBy('createdAt', descending: true).get();

      _admins = snapshot.docs.map((doc) => AdminUser.fromMap({...doc.data(), 'id': doc.id})).toList();
    } catch (e) {
      _error = 'Failed to fetch admins: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAdminStatus(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final doc = await _firestore.collection('admins').doc(userId).get();
      if (doc.exists) {
        _currentAdmin = AdminUser.fromMap({...doc.data()!, 'id': doc.id});
      } else {
        _currentAdmin = null;
      }
    } catch (e) {
      _error = 'Failed to check admin status: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAdmin({
    required String userId,
    required String email,
    required String name,
    required List<String> roles,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final now = DateTime.now();
      final admin = AdminUser(
        id: userId,
        email: email,
        name: name,
        roles: roles,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore.collection('admins').doc(userId).set(admin.toMap());
      _currentAdmin = admin;
    } catch (e) {
      _error = 'Failed to create admin: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAdminRoles({
    required String userId,
    required List<String> roles,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_currentAdmin == null) {
        throw Exception('Admin not found');
      }

      final updatedAdmin = _currentAdmin!.copyWith(
        roles: roles,
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('admins').doc(userId).update(updatedAdmin.toMap());
      _currentAdmin = updatedAdmin;
    } catch (e) {
      _error = 'Failed to update admin roles: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeAdmin(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('admins').doc(userId).delete();
      _currentAdmin = null;
    } catch (e) {
      _error = 'Failed to remove admin: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool hasPermission(String permission) {
    if (_currentAdmin == null) return false;
    return _currentAdmin!.hasRole(permission);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
