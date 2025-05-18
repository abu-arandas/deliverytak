import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

import '../providers/payment_provider.dart';
import '../widgets/payment_form.dart';

class CheckoutPage extends StatelessWidget {
  final String orderId;
  final double amount;
  final String currency;

  const CheckoutPage({
    super.key,
    required this.orderId,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Order ID:'),
                        Text(orderId),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount:'),
                        Text('$currency ${amount.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Consumer<PaymentProvider>(
              builder: (context, paymentProvider, child) {
                return PaymentForm(
                  isLoading: paymentProvider.isLoading,
                  onSubmit: ({
                    required String cardNumber,
                    required int expMonth,
                    required int expYear,
                    required String cvc,
                    required stripe.BillingDetails billingDetails,
                  }) async {
                    try {
                      await paymentProvider.processPayment(
                        orderId: orderId,
                        amount: amount,
                        currency: currency,
                        cardNumber: cardNumber,
                        expMonth: expMonth,
                        expYear: expYear,
                        cvc: cvc,
                        billingDetails: billingDetails,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment successful!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.of(context).pop(true);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Payment failed: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
