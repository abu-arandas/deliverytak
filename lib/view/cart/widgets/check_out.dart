import '/exports.dart';

class CartCheckOut extends StatelessWidget {
  const CartCheckOut({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<CartController>(
        builder: (controller) => Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              if (FirebaseAuth.instance.currentUser != null) {
                try {
                  OrderModel order = OrderModel(
                    id: '',
                    clientId: FirebaseAuth.instance.currentUser!.uid,
                    startTime: DateTime.now(),
                    clientAddress: controller.latLng!,
                    products: CartController.instance.cartProducts,
                    payment: controller.payment,
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
                } catch (error) {
                  errorSnackBar(context, error.toString());
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
                        onPressed: () =>
                            page(context: context, page: const Login()),
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 50),
            ),
            child: const Text('Check Out'),
          ),
        ),
      );
}
