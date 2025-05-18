import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../models/user.dart' as model;
import '../services/storage_service.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  final AuthService authService;

  AuthProvider(this.authService);

  model.User? _currentUser;
  bool _isLoading = false;
  String? _error;

  model.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

        if (userDoc.exists) {
          _currentUser = model.User.fromMap({
            ...userDoc.data()!,
            'id': userDoc.id,
          });
        }
      }
    } catch (e) {
      _error = 'Failed to sign in: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final now = DateTime.now();
        final user = model.User(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          createdAt: now,
          updatedAt: now,
        );

        await _firestore.collection('users').doc(user.id).set(user.toMap());
        _currentUser = user;
      }
    } catch (e) {
      _error = 'Failed to sign up: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to sign out: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(model.User user) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('users').doc(user.id).update(user.toMap());
      _currentUser = user;
    } catch (e) {
      _error = 'Failed to update profile: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Crop image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (croppedFile == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Delete old profile picture if exists
      if (_currentUser?.profilePictureUrl != null) {
        await _storageService.deleteProfilePicture(_currentUser!.profilePictureUrl!);
      }

      // Upload new profile picture
      final imageUrl = await _storageService.uploadProfilePicture(
        _currentUser!.id,
        File(croppedFile.path),
      );

      // Update user profile in Firestore
      await _firestore.collection('users').doc(_currentUser!.id).update({
        'profilePictureUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local user model
      _currentUser = _currentUser!.copyWith(
        profilePictureUrl: imageUrl,
        updatedAt: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
