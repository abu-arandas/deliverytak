import '/exports.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel order;

  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool currentUser = false;
  UserModel? customer;

  @override
  void initState() {
    super.initState();

    users().listen((event) => setState(() {
          customer = event
              .singleWhere((element) => element.id == widget.order.clientId);

          if (widget.order.clientId == FirebaseAuth.instance.currentUser!.uid) {
            currentUser = true;
          }
        }));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,

        // Informations
        content: SingleChildScrollView(
          child: Column(
            children: [
              // Map
              SizedBox(
                width: 500,
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: widget.order.clientAddress,
                    initialZoom: 15,
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
                          point: widget.order.clientAddress,
                          child: const Icon(Icons.location_pin),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Progress
              Container(
                width: 500,
                padding: const EdgeInsets.all(16).copyWith(bottom: 0),
                child: Column(
                  children: [
                    Text(
                      progressDescription(widget.order.progress),
                      style: TextStyle(
                        color: progressColor(widget.order.progress),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) => progressWidget(
                          context: context,
                          progress: widget.order.progress,
                          select: OrderProgress.values[index] ==
                              widget.order.progress,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Time
              Container(
                width: 500,
                padding: const EdgeInsets.all(16).copyWith(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    timeWidget(
                      title: 'Strated',
                      date: widget.order.startTime,
                    ),
                    if (widget.order.acceptTime != null) ...{
                      timeWidget(
                        title: 'Accepted',
                        date: widget.order.acceptTime!,
                      )
                    },
                  ],
                ),
              ),

              // Client
              if (!currentUser && customer != null) ...{
                Container(
                  width: 500,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Client',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ListTile(
                        onTap: () async => await launchUrl(
                          Uri.parse(
                              'https://www.google.com/maps/search/?api=1&query=${widget.order.clientAddress.latitude},-${widget.order.clientAddress.longitude}'),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: customer!.image,
                            fit: BoxFit.fill,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        title: Text(
                          '${customer!.name['first']} ${customer!.name['last']}',
                        ),
                        subtitle: Text(customer!.phone.international),
                      ),
                    ],
                  ),
                ),
              },

              // Price
              price(),

              // Time
              Container(
                width: 500,
                padding: const EdgeInsets.all(16).copyWith(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Method
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.25),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle),
                          child: const Icon(FontAwesomeIcons.dollarSign,
                              color: Colors.white),
                        ),
                        title: Text(
                          paymentDetails(widget.order.payment),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: currentUser
                            ? widget.order.progress != OrderProgress.deleted ||
                                    widget.order.progress != OrderProgress.done
                                ? const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      'Tap Here to select your Payment Method',
                                      style: TextStyle(height: 0.9),
                                    ),
                                  )
                                : null
                            : null,
                      ),
                    ),

                    // Cash on derivery
                    if (currentUser &&
                        widget.order.payment == PaymentMethod.cash) ...{
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Cash on derivery has some potential risks of spreading contamination. You can select other payment methods for a contactless safe delivery.',
                        ),
                      ),
                    },
                  ],
                ),
              ),

              // Divider
              const Padding(
                padding: EdgeInsets.all(16),
                child: Divider(thickness: 1),
              ),

              // Products
              products(context: context, order: widget.order)
            ],
          ),
        ),

        // Buttons
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          // Print
          if (!currentUser) ...{
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: printerLabel(widget.order),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff198754),
              ),
              child: const Text('Print'),
            ),
          },

          if (widget.order.progress == OrderProgress.binding &&
              !currentUser) ...{
            // Start
            ElevatedButton(
              onPressed: () {
                try {
                  ordersCollection.doc(widget.order.id).update(widget.order
                      .copyWith(
                        startTime: DateTime.now(),
                        progress: OrderProgress.inProgress,
                      )
                      .toJson());

                  for (var product in widget.order.products) {
                    singleProduct(product.id).listen((event) {
                      productsCollection.doc(product.id).update({
                        'stock': event.stock - product.stock,
                      });
                    });
                  }

                  succesSnackBar(context, 'Started');
                  Navigator.pop(context);
                } catch (error) {
                  errorSnackBar(context, error.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Start'),
            )
          },

          // Delete
          if (widget.order.progress != OrderProgress.deleted ||
              widget.order.progress != OrderProgress.done) ...{
            ElevatedButton(
              onPressed: () {
                try {
                  ordersCollection.doc(widget.order.id).update(widget.order
                      .copyWith(progress: OrderProgress.deleted)
                      .toJson());

                  succesSnackBar(context, 'Deleted');
                  Navigator.pop(context);
                } catch (error) {
                  errorSnackBar(context, error.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          },
        ],
      );

  Widget progressWidget({
    required BuildContext context,
    required OrderProgress progress,
    required bool select,
  }) {
    return Container(
      height: 2,
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.5),
        color: widget.order.progress == OrderProgress.deleted
            ? const Color(0xffdc3545)
            : select
                ? progressColor(widget.order.progress)
                : Colors.grey,
      ),
    );
  }

  Widget timeWidget({
    required String title,
    required DateTime date,
  }) =>
      ListTile(
        title: Text('$title at'),
        subtitle: Text(
          DateFormat.yMMMMEEEEd().format(date),
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.red),
        ),
      );

  Widget price() {
    double total = 0;

    for (var product in widget.order.products) {
      total += (product.price * product.stock);
    }

    return Container(
      width: 500,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('${total.toStringAsFixed(2)} JD'),
          ),
        ],
      ),
    );
  }

  Widget products({
    required BuildContext context,
    required OrderModel order,
  }) =>
      Column(
        children: List.generate(
          order.products.length,
          (index) => Container(
            margin: const EdgeInsets.all(8).copyWith(top: 0),
            constraints: const BoxConstraints(maxHeight: 125),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  blurStyle: BlurStyle.outer,
                ),
              ],
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadiusDirectional.only(
                    topStart: Radius.circular(12.5),
                    bottomStart: Radius.circular(12.5),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: order.products[index].image,
                    fit: BoxFit.fill,
                  ),
                ),

                // Informations
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  constraints: const BoxConstraints(maxWidth: 175),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        order.products[index].name,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Price && Count
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Text(
                              '${order.products[index].price.toStringAsFixed(2)} JD',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                  minHeight: 25, minWidth: 25),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                order.products[index].stock.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Color & Size
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            if (order.products[index].sizes.isNotEmpty) ...{
                              Text(
                                order.products[index].sizes.first,
                              ),
                            },
                            if (order.products[index].sizes.isNotEmpty &&
                                order.products[index].colors.isNotEmpty) ...{
                              Container(
                                width: 1,
                                height: 10,
                                margin: const EdgeInsets.all(4),
                                color: Colors.grey,
                              ),
                            },
                            if (order.products[index].colors.isNotEmpty) ...{
                              Icon(
                                Icons.circle,
                                color: order.products[index].colors.first.color,
                              ),
                              Text(
                                order.products[index].colors.first.name,
                              ),
                            },
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget printerLabel(OrderModel order) {
    Widget divider() => Container(
          height: 10,
          width: double.maxFinite,
          margin: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: 100,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Container(
              height: 1,
              width: 5,
              color: Colors.black,
              margin: const EdgeInsets.all(4),
            ),
          ),
        );

    Widget data(String title, String info) => Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(
                '${title.tr} : ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                info,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );

    double total = 0;

    for (var element in order.products) {
      total += (total + (element.price * element.stock));
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          // Logo
          App.logo(color: Colors.black),
          divider(),

          // Informations
          const SizedBox(
            width: double.maxFinite,
            child: Text(
              'Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          data('Name', customer!.name['first']),
          data('Phone Number', customer!.phone.international),
          data('Time', DateFormat.yMMMMEEEEd().format(order.startTime)),
          divider(),

          // Products
          const SizedBox(
            width: double.maxFinite,
            child: Text(
              'Products',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ...(List.generate(
            order.products.length,
            (index) {
              double price = 0;

              price = order.products[index].price;

              return Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(order.products[index].name),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      price.toStringAsFixed(2),
                    ),
                    Text(' * ${order.products[index].stock}'),
                  ],
                ),
              );
            },
          )),

          const Divider(thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total : ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(width: 16),
              Text(
                total.toStringAsFixed(2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
