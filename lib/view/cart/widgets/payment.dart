import '/exports.dart';

class CartPayment extends StatefulWidget {
  const CartPayment({super.key});

  @override
  State<CartPayment> createState() => _CartPaymentState();
}

class _CartPaymentState extends State<CartPayment> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController cardHolderController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) => GetBuilder<CartController>(
        builder: (controller) => FB5Row(
          children: [
            FB5Col(
              classNames: 'col-6',
              child: RadioListTile(
                title: Text(paymentMethod.reverse[PaymentMethod.cash]!),
                value: PaymentMethod.cash,
                groupValue: controller.payment,
                onChanged: (value) => controller.setPayment(PaymentMethod.cash),
              ),
            ),
            FB5Col(
              classNames: 'col-6',
              child: RadioListTile(
                title: Text(
                  paymentMethod.reverse[PaymentMethod.online]!,
                  style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                subtitle: const Text(
                  'disabled',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                value: PaymentMethod.online,
                groupValue: controller.payment,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      );

  void onlineForm() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          // Form
          content: Form(
            key: formKey,
            child: Column(
              children: [
                // Card Holder
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Card Holder'),
                  controller: cardHolderController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please input a valid name';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Card Holder
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                  ),
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 16) {
                      return 'Please input a valid number';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Expired Date &
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Expired Date',
                          hintText: 'MM/YY',
                        ),
                        controller: expiryDateController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onChanged: (String value) {
                          if (expiryDateController.text.startsWith(
                            RegExp('[2-9]'),
                          )) {
                            expiryDateController.text =
                                '0${expiryDateController.text}';
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please input a valid date';
                          }

                          final DateTime now = DateTime.now();
                          final List<String> date = value.split(
                            RegExp(r'/'),
                          );
                          final int month = int.parse(date.first);
                          final int year = int.parse('20${date.last}');
                          final int lastDayOfMonth = month < 12
                              ? DateTime(year, month + 1, 0).day
                              : DateTime(year + 1, 1, 0).day;
                          final DateTime cardDate = DateTime(
                              year, month, lastDayOfMonth, 23, 59, 59, 999);

                          if (cardDate.isBefore(now) ||
                              month > 12 ||
                              month == 0) {
                            return 'Please input a valid date';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        obscureText: true,
                        controller: cvvCodeController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          if (value.length == 3) {
                            formKey.currentState!.validate();
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return 'Please input a valid CVV';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Button
          actions: [
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  CartController.instance.setPayment(PaymentMethod.online);
                }
              },
              child: const Text('continue'),
            ),
          ],
        ),
      );
}
