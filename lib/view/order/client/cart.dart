import '/exports.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  LatLng latLng = LocationController.instance.currentLocation!;
  PaymentMethod payment = PaymentMethod.cash;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController cardHolderController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        init: ProductController(),
        builder: (productController) {
          if (productController.cartProducts.isEmpty) {
            return Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.75,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty/cart.png',
                    fit: BoxFit.fill,
                  ),
                  const Text(
                    'Cart is Empty\nDiscover our Products.',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldController.instance
                          .setPage(name: 'shop', widget: const Shop());
                      ScaffoldController.instance.update();
                    },
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                // Map
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: latLng,
                      initialZoom: 15,
                      onMapEvent: (event) =>
                          setState(() => latLng = event.camera.center),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.arandas.deliverytak',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: latLng,
                            child: const Icon(Icons.location_pin,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Products
                section(
                  title: 'Products',
                  body: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: productController.cartProducts.length,
                      itemBuilder: (context, index) => ClientCartProduct(
                        id: productController.cartProducts[index].id,
                      ),
                    ),
                  ),
                ),

                // Payment
                section(
                  title: 'Payment',
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FB5Row(
                        children: List.generate(
                          PaymentMethod.values.length,
                          (index) => FB5Col(
                            classNames: 'col-6',
                            child: RadioListTile(
                              title: Text(paymentMethod
                                  .reverse[PaymentMethod.values[index]]!),
                              value: PaymentMethod.values[index],
                              groupValue: payment,
                              onChanged: (value) => setState(
                                  () => payment = PaymentMethod.values[index]),
                            ),
                          ),
                        ),
                      ),

                      // Online Payment
                      if (payment == PaymentMethod.online) ...{
                        Container(
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // Card Holder
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Card Holder'),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          if (expiryDateController.text
                                              .startsWith(RegExp('[2-9]'))) {
                                            expiryDateController.text =
                                                '0${expiryDateController.text}';
                                          }
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please input a valid date';
                                          }

                                          final DateTime now = DateTime.now();
                                          final List<String> date =
                                              value.split(RegExp(r'/'));
                                          final int month =
                                              int.parse(date.first);
                                          final int year =
                                              int.parse('20${date.last}');
                                          final int lastDayOfMonth = month < 12
                                              ? DateTime(year, month + 1, 0).day
                                              : DateTime(year + 1, 1, 0).day;
                                          final DateTime cardDate = DateTime(
                                              year,
                                              month,
                                              lastDayOfMonth,
                                              23,
                                              59,
                                              59,
                                              999);

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
                                          if (value!.isEmpty ||
                                              value.length < 3) {
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
                        ),
                      }
                    ],
                  ),
                ),

                // Check Out
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '${(productController.cartPrice() + LocationController.instance.calculateDistance(App.address, latLng) + 1).toStringAsFixed(2)} JD',
                        ),
                      ),

                      // Cart
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => validate(),
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      );

  validate() async {
    setState(() => loading = true);

    if (FirebaseAuth.instance.currentUser != null) {
      try {
        OrderModel order = OrderModel(
          id: '',
          clientId: FirebaseAuth.instance.currentUser!.uid,
          startTime: DateTime.now(),
          clientAddress: latLng,
          products: ProductController.instance.cartProducts,
          payment: payment,
          progress: OrderProgress.binding,
        );

        OrderController.instance.ordersCollection.doc().set(order.toJson());

        succesSnackBar('Added');
        ProductController.instance.cartProducts.clear();
        ProductController.instance.update();

        ScaffoldController.instance
            .setPage(name: 'home', widget: const ClientHome());
        ScaffoldController.instance.update();

        setState(() => loading = false);
      } catch (error) {
        errorSnackBar(error.toString());

        setState(() => loading = false);
      }
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('You must be Signed In'),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const Login(),
              ),
              child: const Text('Sign In'),
            ),
          ],
        ),
      );

      setState(() => loading = false);
    }
  }

  Widget section({required String title, required Widget body}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (title != '')
                    Container(
                      width: 50,
                      height: 2,
                      color: Theme.of(context).colorScheme.primary,
                      margin: const EdgeInsets.only(top: 8, bottom: 32),
                    ),
                ],
              ),
            ),

            // Body
            body,
          ],
        ),
      );
}
