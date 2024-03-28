import '/exports.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String type = 'Ongoing';

  Widget tap(String tapType) => type == tapType
      ? OutlinedButton(
          onPressed: () => setState(() => type = tapType),
          child: Text(tapType),
        )
      : TextButton(
          onPressed: () => setState(() => type = tapType),
          child: Text(tapType),
        );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          pageTtitle(
            context: context,
            text: 'Orders',
            bg: 'assets/images/title/orders.jpeg',
          ),

          // Types
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tap('Ongoing'),
              const Text('  |  '),
              tap('History'),
            ],
          ),
          const SizedBox(height: 16),

          // Orders
          FB5Container(
            child: StreamBuilder(
              stream: OrderController.instance
                  .clientOrders(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, ordersSnapshot) {
                if (ordersSnapshot.hasData) {
                  List<OrderModel> orders =
                      ordersSnapshot.data!.where((element) {
                    if (type == 'Ongoing') {
                      return element.progress == OrderProgress.binding ||
                          element.progress == OrderProgress.inProgress;
                    }

                    return true;
                  }).toList();

                  if (orders.isEmpty) {
                    return Container(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 0.75,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
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
                            'assets/images/empty/orders.png',
                            fit: BoxFit.fill,
                          ),
                          const Text(
                            'There is no order right now. You can order now',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
                    return FB5Row(
                      classNames: 'p-3',
                      children: List.generate(
                        orders.length,
                        (index) {
                          double productsPrice = 0;

                          for (ProductModel product in orders[index].products) {
                            productsPrice += product.price * product.stock;
                          }

                          double deliverPrice = LocationController.instance
                              .calculateDistance(
                                  orders[index].clientAddress, App.address);

                          return FB5Col(
                            classNames: 'col-lg-4 col-md-6 col-sm-12 p-3',
                            child: ListTile(
                              onTap: () => ScaffoldController.instance.setPage(
                                name: 'home',
                                widget: OrderDetails(id: orders[index].id),
                              ),
                              leading: Icon(Icons.circle,
                                  color: OrderController.instance
                                      .progressColor(orders[index].progress)),
                              title: Text(
                                orders[index].id,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${orders[index].startTime.month} ${orders[index].startTime.day} : ${orders[index].startTime.hour},${orders[index].startTime.minute}',
                              ),
                              trailing: Text(
                                '${(productsPrice + deliverPrice).toStringAsFixed(2)} JD',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else if (ordersSnapshot.hasError) {
                  return Center(child: Text(ordersSnapshot.error.toString()));
                } else if (ordersSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      );
}
