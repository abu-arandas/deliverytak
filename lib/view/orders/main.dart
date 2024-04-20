import '/exports.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String type = 'Ongoing';

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  orderTap(context, 'Ongoing'),
                  const Text('  |  '),
                  orderTap(context, 'History'),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              child: StreamBuilder(
                stream: singleUser(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasData) {
                    Stream<List<OrderModel>> stream;

                    if (userSnapshot.data!.role == UserRole.client) {
                      stream = clientOrders(userSnapshot.data!.id);
                    } else {
                      stream = orders();
                    }

                    return StreamBuilder(
                      stream: stream,
                      builder: (context, ordersSnapshot) {
                        if (ordersSnapshot.hasData) {
                          return ordersData(context, ordersSnapshot.data!);
                        } else if (ordersSnapshot.hasError) {
                          return Center(
                              child: Text(ordersSnapshot.error.toString()));
                        } else if (ordersSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return Container();
                        }
                      },
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
              ),
            ),
          ],
        ),
      );

  Widget orderTap(BuildContext context, String tapType) => tapType == type
      ? ElevatedButton(
          onPressed: () => setState(() => type = tapType),
          child: Text(tapType),
        )
      : OutlinedButton(
          onPressed: () => setState(() => type = tapType),
          child: Text(tapType),
        );

  Widget ordersData(BuildContext context, List<OrderModel> orders) {
    orders = orders.where((element) {
      if (type == 'Ongoing') {
        return element.progress == OrderProgress.binding ||
            element.progress == OrderProgress.inProgress;
      }

      return true;
    }).toList();

    orders.sort((a, b) => a.startTime.compareTo(b.startTime));

    if (orders.isNotEmpty) {
      return FB5Row(
        children: List.generate(
          orders.length,
          (index) {
            double total = 0;

            for (var product in orders[index].products) {
              total += (product.price * product.stock);
            }

            return FB5Col(
              classNames: 'col-lg-4 col-md-6 col-sm-12 p-3',
              child: ListTile(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => OrderDetails(order: orders[index]),
                ),
                leading: Icon(
                  Icons.circle,
                  color: progressColor(orders[index].progress),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    progressDescription(orders[index].progress),
                  ),
                ),
                subtitle: Text(
                  DateFormat.yMEd().format(orders[index].startTime),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(
                  '${total.toStringAsFixed(2)} JD',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.sizeOf(context).height - 100,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/empty%2Forders.png?alt=media&token=66cf5364-2066-4bb2-88e9-f21cebf34da9'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Text(
                'There is no ongoing order right now. You can order now',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
  }
}
