import '/exports.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  LatLng latLng = LocationController.instance.currentLocation;
  PaymentMethod payment = PaymentMethod.cash;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController cardHolderController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();

  bool loading = false;

  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) => ClientScaffold(
        pageName: 'cart',
        pageImage:
            'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/title%2Fcart.jpeg?alt=media&token=eeade872-dd24-4767-a0b0-1f27f33a9ecd',
        body: GetBuilder<CartController>(
          builder: (productController) {
            if (productController.cartProducts.isEmpty) {
              return Container(
                width: 400,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.75,
                ),
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/empty%2Fcart.png?alt=media&token=8eb2f914-7ed3-4b44-9e25-bd9a554c6caf'),
                    ),
                    Text(
                      'Cart is Empty\nDiscover our Products.',
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => page(
                        context: context,
                        page: const ClientShop(),
                      ),
                      child: const Text('Shop Now'),
                    ),
                  ],
                ),
              );
            } else {
              return FB5Container(
                child: FB5Row(
                  children: [
                    // Products
                    FB5Col(
                      classNames: 'col-12 p-3',
                      child: StreamBuilder(
                        stream: products(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Table(
                              columnWidths: const {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(4),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(2),
                                4: FlexColumnWidth(2),
                              },
                              children: [
                                // Title
                                const TableRow(
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide()),
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text('image'),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text('title'),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text('price'),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text('size'),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text('count'),
                                    ),
                                  ],
                                ),

                                // Products
                                for (ProductModel product
                                    in productController.cartProducts) ...{
                                  productRow(
                                    productController,
                                    snapshot.data!.singleWhere(
                                        (element) => element.id == product.id),
                                  ),
                                }
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                              snapshot.error.toString(),
                            ));
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),

                    // Pilling
                    FB5Col(
                      classNames: 'col-lg-7 col-md-6 col-sm-12 col-xs-12 p-3',
                      child: Form(
                        child: Column(
                          children: [
                            // Map
                            SizedBox(
                              height:
                                  MediaQuery.sizeOf(context).width >= 1000 &&
                                          key.currentContext != null
                                      ? key.currentContext!.height
                                      : 400,
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: latLng,
                                  initialZoom: 15,
                                  onMapEvent: (event) => setState(
                                      () => latLng = event.camera.center),
                                  onTap: (tapPosition, point) =>
                                      setState(() => latLng = point),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.arandas.deliverytak',
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

                            // Payment
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
                                    onChanged: (value) => setState(() =>
                                        payment = PaymentMethod.values[index]),
                                  ),
                                ),
                              ),
                            ),

                            // Online Payment
                            if (payment == PaymentMethod.online) ...{
                              Container(
                                padding: const EdgeInsets.all(8),
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: onlineForm(),
                              ),
                            },
                          ],
                        ),
                      ),
                    ),

                    // Additional
                    FB5Col(
                      classNames: 'col-lg-5 col-md-6 col-sm-12 col-xs-12 p-3',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Products Price
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: 'Products : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: productController
                                      .cartPrice()
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),

                          // Deliver Price
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Deliver : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '1'),
                              ],
                            ),
                          ),

                          // Products Price
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: 'Total : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: (productController.cartPrice() + 1)
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),

                          const Divider(),

                          // Check Out
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () => validate(),
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(200, 50),
                              ),
                              child: const Text('Check Out'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );

  TableRow productRow(
    CartController productController,
    ProductModel product,
  ) {
    String? size = product.sizes.isEmpty ? product.sizes.first : null;
    int stock = productController.cartProducts
        .singleWhere((element) => element.id == product.id)
        .stock;

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: CachedNetworkImage(
            imageUrl: product.image,
            fit: BoxFit.fill,
            width: 75,
            height: 75,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(product.name),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(product.price.toStringAsFixed(2)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: PopupMenuButton(
            itemBuilder: (BuildContext context) => List.generate(
              product.sizes.length,
              (index) => PopupMenuItem(
                onTap: () {
                  setState(() => size = product.sizes[index]);

                  productController.cartProducts
                      .singleWhere((element) => element.id == product.id)
                      .sizes = [product.sizes[index]];

                  productController.update();
                },
                child: Text(product.sizes[index]),
              ),
            ),
            child: ListTile(
              title: Text(
                size ?? 'Selecet a Size',
                style: const TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(stock.toString()),
              Column(
                children: [
                  if (stock <= product.stock) ...{
                    InkWell(
                      onTap: () {
                        setState(() => stock++);

                        productController.cartProducts
                            .singleWhere((element) => element.id == product.id)
                            .stock++;
                        productController.update();
                      },
                      child: const Icon(Icons.keyboard_arrow_up),
                    )
                  },
                  if (stock >= 1) ...{
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        if (stock == 1) {
                          setState(() => stock = 0);

                          productController.cartProducts.removeWhere(
                              (element) => element.id == product.id);
                        } else {
                          setState(() => stock--);

                          productController.cartProducts
                              .singleWhere(
                                  (element) => element.id == product.id)
                              .stock--;
                        }

                        productController.update();
                      },
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  }
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget onlineForm() => Form(
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

                      if (cardDate.isBefore(now) || month > 12 || month == 0) {
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
          products: CartController.instance.cartProducts,
          payment: payment,
          progress: OrderProgress.binding,
        );

        ordersCollection.doc().set(order.toJson());

        succesSnackBar(context, 'Added');
        CartController.instance.cartProducts.clear();
        CartController.instance.update();

        users().listen((event) {
          for (var admin in event
              .where((element) => element.role == UserRole.admin)
              .toList()) {
            NotificationController.instance.sendMessage(
              context: context,
              token: admin.token,
              title: 'New Order',
              body: 'there is a new order check it',
            );
          }
        });

        page(context: context, page: const Main());

        setState(() => loading = false);
      } catch (error) {
        errorSnackBar(context, error.toString());

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
              onPressed: () => page(context: context, page: const Login()),
              child: const Text('Sign In'),
            ),
          ],
        ),
      );

      setState(() => loading = false);
    }
  }
}
