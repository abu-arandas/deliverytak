import '/exports.dart';

class OrderDetails extends StatelessWidget {
  final String id;
  const OrderDetails({super.key, required this.id});

  Widget summery(String title, String data) => Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$title :', style: const TextStyle(color: Colors.black87)),
            Text(data, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: OrderController.instance.singleOrder(id),
        builder: (context, orderSnapshot) {
          if (orderSnapshot.hasData) {
            return StreamBuilder(
              stream: UserController.instance
                  .singletUser(orderSnapshot.data!.clientId),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  double productsPrice = 0;

                  for (ProductModel product in orderSnapshot.data!.products) {
                    productsPrice += product.price * product.stock;
                  }

                  double deliverPrice = LocationController.instance
                      .calculateDistance(
                          orderSnapshot.data!.clientAddress, App.address);

                  return FB5Row(
                    children: [
                      // Information's
                      FB5Col(
                        classNames: 'col-lg-8 col-md-8 col-sm-12',
                        child: Column(
                          children: [
                            // Map
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter:
                                      orderSnapshot.data!.clientAddress,
                                  initialZoom: 15,
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
                                        point:
                                            orderSnapshot.data!.clientAddress,
                                        child: const Icon(Icons.location_pin,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // -- Order Summery
                            Container(
                              width: 500,
                              padding: const EdgeInsets.all(16),
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Order Summery',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    // Progress
                                    ListTile(
                                      leading: Icon(
                                        Icons.circle,
                                        color: OrderController.instance
                                            .progressColor(
                                                orderSnapshot.data!.progress),
                                      ),
                                      title: Text(
                                        orderProgress.reverse[
                                            orderSnapshot.data!.progress]!,
                                      ),
                                      subtitle: Text(
                                        OrderController.instance
                                            .progressDescription(
                                                orderSnapshot.data!.progress),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    // Payment
                                    ListTile(
                                      title: const Text('Payment Method'),
                                      subtitle: Text(
                                        paymentMethod.reverse[
                                            orderSnapshot.data!.payment]!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    summery(
                                      'Created at',
                                      '${orderSnapshot.data!.startTime.month} ${orderSnapshot.data!.startTime.day} : ${orderSnapshot.data!.startTime.hour},${orderSnapshot.data!.startTime.minute}',
                                    ),
                                    summery(
                                      'Products price',
                                      '${productsPrice.toStringAsFixed(2)} JD',
                                    ),
                                    summery(
                                      'Deliver price',
                                      '${deliverPrice.toStringAsFixed(2)} JD',
                                    ),
                                    const Divider(),
                                    summery(
                                      'Total',
                                      '${(productsPrice + deliverPrice).toStringAsFixed(2)} JD',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Products
                      FB5Col(
                        classNames: 'col-lg-4 col-md-4 col-sm-12 p-3',
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Products',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              FB5Row(
                                children: List.generate(
                                  orderSnapshot.data!.products.length,
                                  (index) => FB5Col(
                                    classNames:
                                        'col-lg-12 col-md-12 col-sm-6 p-3',
                                    child: Flexible(
                                      child: ListTile(
                                        isThreeLine: true,

                                        // -- Image
                                        leading: Container(
                                          width: 75,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.5),
                                            image: DecorationImage(
                                              image: NetworkImage(orderSnapshot
                                                  .data!
                                                  .products[index]
                                                  .imageUrl),
                                              fit: BoxFit.fill,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 10,
                                                blurStyle: BlurStyle.outer,
                                              ),
                                            ],
                                          ),
                                        ),

                                        // -- Title
                                        title: Text(
                                          orderSnapshot
                                              .data!.products[index].name,
                                          style: const TextStyle(fontSize: 16),
                                        ),

                                        // -- Price
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            '${(orderSnapshot.data!.products[index].price * orderSnapshot.data!.products[index].stock).toStringAsFixed(2)} JD',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),

                                        // -- Quantity
                                        trailing: Text(
                                            '* ${orderSnapshot.data!.products[index].stock}'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (userSnapshot.hasError) {
                  return Center(child: Text(userSnapshot.error.toString()));
                } else if (userSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            );
          } else if (orderSnapshot.hasError) {
            return Center(child: Text(orderSnapshot.error.toString()));
          } else if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      );
}
