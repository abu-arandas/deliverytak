import '/exports.dart';

CollectionReference<Map<String, dynamic>> ordersCollection =
    FirebaseFirestore.instance.collection('orders');

Stream<List<OrderModel>> orders() => ordersCollection.snapshots().map(
    (query) => query.docs.map((item) => OrderModel.fromJson(item)).toList());
Stream<OrderModel> singleOrder(id) => ordersCollection
    .doc(id)
    .snapshots()
    .map((query) => OrderModel.fromJson(query));
Stream<List<OrderModel>> clientOrders(String id) =>
    ordersCollection.snapshots().map(
          (query) => query.docs
              .map((item) => OrderModel.fromJson(item))
              .where((element) => element.clientId == id)
              .toList(),
        );
Stream<List<OrderModel>> driverOrders(String id) =>
    ordersCollection.snapshots().map(
          (query) => query.docs
              .map((item) => OrderModel.fromJson(item))
              .where((element) => element.driverId == id)
              .toList(),
        );

void addOrder({required BuildContext context}) =>
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        try {
          OrderModel order = OrderModel(
            id: '',
            clientId: FirebaseAuth.instance.currentUser!.uid,
            startTime: DateTime.now(),
            clientAddress: CartController.instance.latLng!,
            products: CartController.instance.cartProducts,
            payment: CartController.instance.payment,
            progress: OrderProgress.binding,
          );

          ordersCollection
              .doc(Random().nextInt(999999).toString())
              .set(order.toJson());

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
          succesSnackBar(context, 'Added');
        } on FirebaseException catch (error) {
          errorSnackBar(context, error.message.toString());
        }
      } else {
        showDialog(
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
      }
    });

void pickOrder({
  required BuildContext context,
  required String id,
}) {
  try {
    var res = page(
      context: context,
      page: const SimpleBarcodeScannerPage(),
    );

    if (res == id) {
      ordersCollection.doc(id).update({
        'pickTime': DateTime.now(),
        'progress': orderProgress.reverse[OrderProgress.done],
      });
    } else {
      errorSnackBar(context, 'not the same order');
    }
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void deleteOrder({
  required BuildContext context,
  required String id,
  required String clientId,
}) {
  try {
    ordersCollection
        .doc(id)
        .update({'progress': orderProgress.reverse[OrderProgress.deleted]});

    singleUser(clientId).listen((event) {
      NotificationController.instance.sendMessage(
        context: context,
        token: event.token,
        title: 'Order Deleted',
        body:
            'Order number $id is ${orderProgress.reverse[OrderProgress.deleted]}',
      );
    });

    succesSnackBar(context, 'Deleted');
    Navigator.pop(context);
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}
