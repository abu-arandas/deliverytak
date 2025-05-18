import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class AuthService {
  final FirebaseAuth _auth;
  final Logger _logger;

  AuthService([
    FirebaseAuth? auth,
    Logger? logger,
  ])  : _auth = auth ?? FirebaseAuth.instance,
        _logger = logger ?? Logger('AuthService');

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Signing in user: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.info('User signed in successfully');
      return credential;
    } catch (e) {
      _logger.severe('Error signing in user: $e');
      rethrow;
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Creating user: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.info('User created successfully');
      return credential;
    } catch (e) {
      _logger.severe('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      _logger.info('Signing out user');
      await _auth.signOut();
      _logger.info('User signed out successfully');
    } catch (e) {
      _logger.severe('Error signing out user: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _logger.info('Resetting password for user: $email');
      await _auth.sendPasswordResetEmail(email: email);
      _logger.info('Password reset email sent successfully');
    } catch (e) {
      _logger.severe('Error resetting password: $e');
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      _logger.info('Updating password for user');
      await _auth.currentUser?.updatePassword(newPassword);
      _logger.info('Password updated successfully');
    } catch (e) {
      _logger.severe('Error updating password: $e');
      rethrow;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      _logger.info('Updating email for user');
      await _auth.currentUser?.updateEmail(newEmail);
      _logger.info('Email updated successfully');
    } catch (e) {
      _logger.severe('Error updating email: $e');
      rethrow;
    }
  }
}
