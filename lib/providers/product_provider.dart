import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _featuredProducts = [];

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get featuredProducts => _featuredProducts;

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestore.collection('products').get();
      _products = snapshot.docs.map((doc) => Product.fromMap({...doc.data(), 'id': doc.id})).toList();
    } catch (e) {
      _error = 'Failed to fetch products: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final now = DateTime.now();
      final productWithTimestamps = product.copyWith(
        createdAt: now,
        updatedAt: now,
      );

      final docRef = await _firestore.collection('products').add(productWithTimestamps.toMap());
      _products.add(productWithTimestamps.copyWith(id: docRef.id));
    } catch (e) {
      _error = 'Failed to add product: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedProduct = product.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('products').doc(product.id).update(updatedProduct.toMap());
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
    } catch (e) {
      _error = 'Failed to update product: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('products').doc(productId).delete();
      _products.removeWhere((product) => product.id == productId);
    } catch (e) {
      _error = 'Failed to delete product: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  List<String> getCategories() {
    return _products.map((product) => product.category).toSet().toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> fetchFeaturedProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestore.collection('products').where('isFeatured', isEqualTo: true).limit(8).get();

      _featuredProducts = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> searchProducts({
    String? searchQuery,
    List<String>? categories,
    List<String>? brands,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection('products');

      if (categories != null && categories.isNotEmpty) {
        query = query.where('category', whereIn: categories);
      }

      if (brands != null && brands.isNotEmpty) {
        query = query.where('brand', whereIn: brands);
      }

      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }

      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      final snapshot = await query.get();

      List<Map<String, dynamic>> products = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();

      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        products = products.where((product) {
          final name = product['name']?.toString().toLowerCase() ?? '';
          final description = product['description']?.toString().toLowerCase() ?? '';
          return name.contains(query) || description.contains(query);
        }).toList();
      }

      return products;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          return {
            'id': doc.id,
            ...data,
          };
        }
      }
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
