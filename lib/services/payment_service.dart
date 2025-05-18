import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../models/payment.dart';
import 'stripe_service.dart';
import 'package:logging/logging.dart';

class PaymentService {
  final FirebaseFirestore _firestore;
  final StripeService _stripeService;
  final Logger _logger;

  PaymentService({
    required FirebaseFirestore firestore,
    required StripeService stripeService,
    Logger? logger,
  })  : _firestore = firestore,
        _stripeService = stripeService,
        _logger = logger ?? Logger('PaymentService');

  Future<void> initialize() async {
    await _stripeService.initialize();
  }

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
      _logger.info('Processing payment for order $orderId');

      // Create payment method
      final paymentMethod = await _stripeService.createPaymentMethod(
        cardNumber: cardNumber,
        expMonth: expMonth,
        expYear: expYear,
        cvc: cvc,
        billingDetails: billingDetails,
      );

      // Create payment intent
      final paymentIntent = await _stripeService.createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      // Confirm payment
      await _stripeService.confirmPayment(
        clientSecret: paymentIntent.clientSecret!,
        paymentMethod: paymentMethod,
      );

      _logger.info('Payment processed successfully for order $orderId');
    } catch (e) {
      _logger.severe('Error processing payment for order $orderId: $e');
      rethrow;
    }
  }

  Future<void> refundPayment({
    required String paymentId,
    required double amount,
  }) async {
    try {
      _logger.info('Processing refund for payment $paymentId');

      await _stripeService.refundPayment(
        paymentIntentId: paymentId,
        amount: (amount * 100).toInt(), // Convert to cents
      );

      _logger.info('Refund processed successfully for payment $paymentId');
    } catch (e) {
      _logger.severe('Error processing refund for payment $paymentId: $e');
      rethrow;
    }
  }

  Stream<List<Payment>> getPaymentsByOrderId(String orderId) {
    return _firestore
        .collection('payments')
        .where('orderId', isEqualTo: orderId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Payment.fromMap(doc.data())).toList());
  }
}
