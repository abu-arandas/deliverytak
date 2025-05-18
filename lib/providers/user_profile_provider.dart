import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/user_profile.dart';

class UserProfileProvider with ChangeNotifier {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProfile(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _profile = UserProfile.fromMap({...doc.data()!, 'id': doc.id});
      }
    } catch (e) {
      _error = 'Failed to fetch profile: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProfile({
    required String userId,
    required String email,
    required String name,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final now = DateTime.now();
      final profile = UserProfile(
        id: userId,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore.collection('users').doc(userId).set(profile.toMap());
      _profile = profile;
    } catch (e) {
      _error = 'Failed to create profile: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_profile == null) {
        throw Exception('Profile not found');
      }

      final updatedProfile = _profile!.copyWith(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(userId).update(updatedProfile.toMap());
      _profile = updatedProfile;
    } catch (e) {
      _error = 'Failed to update profile: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
