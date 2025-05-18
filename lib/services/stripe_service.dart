import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:logging/logging.dart';

class StripeService {
  static const String _baseUrl = 'https://api.stripe.com/v1';
  final String _secretKey;
  final String _publishableKey;
  final Logger _logger = Logger('StripeService');

  StripeService({
    required String secretKey,
    required String publishableKey,
  })  : _secretKey = secretKey,
        _publishableKey = publishableKey;

  Future<void> initialize() async {
    try {
      Stripe.publishableKey = _publishableKey;
      await Stripe.instance.applySettings();
    } catch (e) {
      _logger.severe('Error initializing Stripe: $e');
      rethrow;
    }
  }

  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (amount * 100).toInt().toString(), // Convert to cents
          'currency': currency.toLowerCase(),
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        return PaymentIntent.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      _logger.severe('Error creating payment intent: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createPaymentMethod({
    required String cardNumber,
    required int expMonth,
    required int expYear,
    required String cvc,
    required BillingDetails billingDetails,
  }) async {
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );
      return paymentMethod.toJson();
    } catch (e) {
      _logger.severe('Error creating payment method: $e');
      rethrow;
    }
  }

  Future<void> confirmPayment({
    required String clientSecret,
    required Map<String, dynamic> paymentMethod,
  }) async {
    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: paymentMethod['email'],
              name: paymentMethod['name'],
              address: Address(
                city: paymentMethod['city'],
                country: paymentMethod['country'],
                line1: paymentMethod['line1'],
                line2: paymentMethod['line2'],
                postalCode: paymentMethod['postalCode'],
                state: paymentMethod['state'],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      _logger.severe('Error confirming payment: $e');
      rethrow;
    }
  }

  Future<void> refundPayment({
    required String paymentIntentId,
    required int amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/refunds'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'payment_intent': paymentIntentId,
          'amount': amount.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to refund payment: ${response.body}');
      }
    } catch (e) {
      _logger.severe('Error refunding payment: $e');
      rethrow;
    }
  }
}

class PaymentIntent {
  final String id;
  final int amount;
  final String currency;
  final String status;
  final String? clientSecret;
  final Map<String, dynamic> metadata;

  PaymentIntent({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    this.clientSecret,
    required this.metadata,
  });

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      id: json['id'],
      amount: json['amount'],
      currency: json['currency'],
      status: json['status'],
      clientSecret: json['client_secret'],
      metadata: json['metadata'] ?? {},
    );
  }
}
