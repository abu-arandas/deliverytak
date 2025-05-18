import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../services/payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _currentPayment;

  PaymentProvider(this._paymentService);

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get currentPayment => _currentPayment;

  Future<void> processPayment({
    required String orderId,
    required double amount,
    required String currency,
    required String cardNumber,
    required int expMonth,
    required int expYear,
    required String cvc,
    required BillingDetails billingDetails,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _paymentService.processPayment(
        orderId: orderId,
        amount: amount,
        currency: currency,
        cardNumber: cardNumber,
        expMonth: expMonth,
        expYear: expYear,
        cvc: cvc,
        billingDetails: billingDetails,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> refundPayment({
    required String paymentId,
    required double amount,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _paymentService.refundPayment(
        paymentId: paymentId,
        amount: amount,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
