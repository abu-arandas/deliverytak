import '/exports.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

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
                    FB5Col(
                      classNames: 'col-12 p-3',
                      child: const CartProducts(),
                    ),
                    FB5Col(
                      classNames: 'col-lg-7 col-md-6 col-sm-12 col-xs-12 p-3',
                      child: const CartMap(),
                    ),
                    FB5Col(
                      classNames: 'col-lg-5 col-md-6 col-sm-12 col-xs-12 p-3',
                      child: const SizedBox(
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CartPayment(),
                            CartPrice(),
                            Spacer(),
                            Divider(),
                            CartCheckOut(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
}
