import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wishlist_item.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<WishlistItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<WishlistItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWishlist(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('wishlists')
          .where('userId', isEqualTo: userId)
          .orderBy('addedAt', descending: true)
          .get();

      _items = snapshot.docs.map((doc) => WishlistItem.fromMap({...doc.data(), 'id': doc.id})).toList();
    } catch (e) {
      _error = 'Failed to fetch wishlist: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToWishlist({
    required String userId,
    required Product product,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Check if product is already in wishlist
      final existingItem = _items.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => WishlistItem(
          id: '',
          userId: '',
          product: product,
          addedAt: DateTime.now(),
        ),
      );

      if (existingItem.id.isNotEmpty) {
        _error = 'Product is already in your wishlist';
        return;
      }

      final docRef = await _firestore.collection('wishlists').add({
        'userId': userId,
        'product': product.toMap(),
        'addedAt': Timestamp.now(),
      });

      final newItem = WishlistItem(
        id: docRef.id,
        userId: userId,
        product: product,
        addedAt: DateTime.now(),
      );

      _items.insert(0, newItem);
    } catch (e) {
      _error = 'Failed to add to wishlist: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String itemId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('wishlists').doc(itemId).delete();
      _items.removeWhere((item) => item.id == itemId);
    } catch (e) {
      _error = 'Failed to remove from wishlist: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isInWishlist(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
