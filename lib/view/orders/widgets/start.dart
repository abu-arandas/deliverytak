import '/exports.dart';

class SingleOrderStartButton extends StatelessWidget {
  final OrderModel order;
  const SingleOrderStartButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: singleUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.role == UserRole.admin &&
                order.progress == OrderProgress.binding) {
              return ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    // Title
                    title: const Text('Available Drivers'),

                    // Drivers
                    content: StreamBuilder(
                      stream: drivers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<UserModel> data = snapshot.data!
                              .where((element) => element.address != null)
                              .toList();

                          List<Map> drivers = List.generate(
                            data.length,
                            (index) => {
                              'user': data[index],
                              'distance': Geolocator.distanceBetween(
                                data[index].address!.latitude,
                                data[index].address!.longitude,
                                App.address.latitude,
                                App.address.longitude,
                              ),
                            },
                          );

                          drivers.sort(
                            (a, b) => a['distance'].compareTo(b['distance']),
                          );

                          if (drivers.isNotEmpty) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                drivers.length,
                                (index) => driver(
                                  context: context,
                                  user: drivers[index]['user'],
                                  distance: drivers[index]['distance'],
                                ),
                              ),
                            );
                          } else {
                            return CachedNetworkImage(
                                imageUrl:
                                    'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/empty%2Forders.png?alt=media&token=66cf5364-2066-4bb2-88e9-f21cebf34da9');
                          }
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text('Start'),
              );
            } else {
              return Container();
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      );

  Widget driver({
    required BuildContext context,
    required UserModel user,
    required double distance,
  }) =>
      ListTile(
        // Select
        onTap: () {
          try {
            ordersCollection.doc(order.id).update(order
                .copyWith(
                  startTime: DateTime.now(),
                  driverId: user.id,
                  progress: OrderProgress.inProgress,
                )
                .toJson());

            for (var product in order.products) {
              singleProduct(product.id).listen((event) {
                productsCollection.doc(product.id).update({
                  'stock': event.stock - product.stock,
                });
              });
            }

            NotificationController.instance.sendMessage(
              context: context,
              token: user.token,
              title: 'New Order',
              body: 'there is a new order check it',
            );

            singleUser(order.clientId).listen((event) {
              NotificationController.instance.sendMessage(
                context: context,
                token: event.token,
                title: 'Order Started',
                body:
                    'Order number ${order.id} is ${orderProgress.reverse[order.progress]}',
              );
            });

            succesSnackBar(context, 'Started');
            Navigator.pop(context);
          } catch (error) {
            errorSnackBar(context, error.toString());
          }
        },

        // Name
        title: Text('${user.name['first']} ${user.name['last']}'),

        // Distance
        subtitle: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            distance.toStringAsFixed(2),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
}
