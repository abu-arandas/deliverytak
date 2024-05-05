import '/exports.dart';

class SingleOrderDeliverButton extends StatelessWidget {
  final OrderModel order;
  const SingleOrderDeliverButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: singleUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.role == UserRole.driver &&
                order.progress == OrderProgress.inProgress &&
                order.driverId == snapshot.data!.id) {
              return ElevatedButton(
                onPressed: () async {
                  try {
                    var res = page(
                      context: context,
                      page: const SimpleBarcodeScannerPage(),
                    );

                    if (res == order.id) {
                      ordersCollection.doc(order.id).update(order
                          .copyWith(
                            pickTime: DateTime.now(),
                            progress: OrderProgress.done,
                          )
                          .toJson());
                    } else {
                      errorSnackBar(context, 'not the same order');
                    }
                  } catch (error) {
                    errorSnackBar(context, error.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text('Deliver'),
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
}
