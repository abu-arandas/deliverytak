import '/exports.dart';

class ClientProductWidget extends StatelessWidget {
  final ProductModel product;
  const ClientProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => page(
          context: context,
          page: ProductDetails(id: product.id),
        ),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: product.images.first,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned.fill(
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  color: Colors.black.withOpacity(0.25),
                ),
              ),
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Name
                      Padding(
                        padding: const EdgeInsets.all(8).copyWith(bottom: 16),
                        child: Text(
                          product.name,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),

                      // Details
                      GetBuilder<CartController>(
                        builder: (controller) => ElevatedButton(
                          onPressed: () {
                            controller.cartProducts.add(
                              CartModel(
                                id: product.id,
                                color: 0,
                                size: 0,
                                stock: 1,
                              ),
                            );

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Added to cart'),
                                content: Row(children: [
                                  Expanded(
                                    flex: 3,
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Continue Shopping'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: () => page(
                                        context: context,
                                        page: const Cart(),
                                      ),
                                      child: const Text('View Cart'),
                                    ),
                                  ),
                                ]),
                              ),
                            );

                            controller.update();
                          },
                          style: ButtonStyle(
                            shape: const WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            backgroundColor: WidgetStateColor.resolveWith(
                              (states) => states
                                          .contains(WidgetState.hovered) ||
                                      states.contains(WidgetState.focused) ||
                                      states.contains(WidgetState.pressed)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            foregroundColor: WidgetStateColor.resolveWith(
                              (states) => states
                                          .contains(WidgetState.hovered) ||
                                      states.contains(WidgetState.focused) ||
                                      states.contains(WidgetState.pressed)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                            ),
                          ),
                          child: Text(
                              'Shop Now : ${product.price.toStringAsFixed(2)} JD'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
