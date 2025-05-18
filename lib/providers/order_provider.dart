import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _orders = snapshot.docs.map((doc) => Order.fromMap({...doc.data(), 'id': doc.id})).toList();
    } catch (e) {
      _error = 'Failed to fetch orders: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllOrders() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestore.collection('orders').orderBy('createdAt', descending: true).get();

      _orders = snapshot.docs.map((doc) => Order.fromMap({...doc.data(), 'id': doc.id})).toList();
    } catch (e) {
      _error = 'Failed to fetch orders: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createOrder({
    required String userId,
    required List<CartItem> items,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final order = Order(
        id: '', // Will be set by Firestore
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        status: 'pending',
        createdAt: DateTime.now(),
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
      );

      final docRef = await _firestore.collection('orders').add(order.toMap());
      _orders.insert(
        0,
        order.copyWith(id: docRef.id),
      );
    } catch (e) {
      _error = 'Failed to create order: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });

      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: status);
      }
    } catch (e) {
      _error = 'Failed to update order status: ${e.toString()}';
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
