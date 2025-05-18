import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    try {
      // Create a unique filename
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final storageRef = _storage.ref().child('profile_pictures/$userId/$fileName');

      // Upload the file
      final uploadTask = await storageRef.putFile(imageFile);

      // Get the download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture: ${e.toString()}');
    }
  }

  Future<void> deleteProfilePicture(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete profile picture: ${e.toString()}');
    }
  }
}
