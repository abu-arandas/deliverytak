import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../models/payment.dart';
import '../services/payment_service.dart';

final paymentServiceProvider = Provider<PaymentService>(
  create: (_) => throw UnimplementedError('PaymentService provider must be initialized'),
);

final paymentProvider = ChangeNotifierProvider<PaymentNotifier>(
  create: (context) {
    final paymentService = context.read<PaymentService>();
    return PaymentNotifier(paymentService);
  },
);

class PaymentNotifier extends ChangeNotifier {
  final PaymentService _paymentService;
  Payment? _payment;
  bool _isLoading = false;
  String? _error;

  PaymentNotifier(this._paymentService);

  Payment? get payment => _payment;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
    }
  }

  Stream<List<Payment>> getPaymentsByOrderId(String orderId) {
    return _paymentService.getPaymentsByOrderId(orderId);
  }
}
