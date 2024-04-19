import '/exports.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  RxList<ProductModel> cartProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    for (var product in cartProducts) {
      singleProduct(product.id).listen((event) {
        while (product.stock > event.stock) {
          product.stock--;
          update();

          errorSnackBar(
            Get.context!,
            'check your cart items we increase oe of them',
          );
        }
      });

      while (product.stock <= 0) {
        cartProducts.removeWhere((element) => element.id == product.id);
        update();

        errorSnackBar(
          Get.context!,
          'check your cart items we remove oe of them',
        );
      }
    }
  }

  Widget cartButton({
    required String id,
    ColorModel? color,
    String? size,
    Color? bgColor,
  }) =>
      StreamBuilder(
        stream: singleProduct(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GetBuilder<CartController>(
              builder: (controller) {
                bool exists =
                    controller.cartProducts.any((element) => element.id == id);
                int count = exists
                    ? controller.cartProducts
                        .singleWhere((element) => element.id == id)
                        .stock
                    : 1;

                return Row(
                  children: [
                    // Remove
                    if (exists) ...{
                      IconButton(
                        onPressed: () {
                          if (count > 1) {
                            controller.cartProducts
                                .singleWhere((element) => element.id == id)
                                .stock--;
                            controller.update();
                          } else {
                            controller.cartProducts
                                .removeWhere((element) => element.id == id);
                            controller.update();
                          }
                        },
                        icon: Icon(Icons.remove, color: bgColor),
                      )
                    },

                    // Count
                    if (exists) ...{
                      Text(
                        count.toString(),
                        style: TextStyle(color: bgColor),
                      )
                    },

                    // Add
                    if (snapshot.data!.stock >= count) ...{
                      IconButton(
                        onPressed: () {
                          if (exists) {
                            controller.cartProducts
                                .singleWhere((element) => element.id == id)
                                .copyWith(
                                  colors: color != null ? [color] : null,
                                  sizes: size != null ? [size] : null,
                                  stock: count++,
                                );
                          } else {
                            controller.cartProducts.add(
                              snapshot.data!.copyWith(
                                colors: color != null ? [color] : null,
                                sizes: size != null ? [size] : null,
                                stock: 1,
                              ),
                            );
                          }

                          controller.update();
                        },
                        icon: Icon(
                          exists ? Icons.add : Icons.shopping_cart,
                          color: bgColor,
                        ),
                      )
                    },
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        },
      );

  double cartPrice() {
    double total = 0;

    for (var product in cartProducts) {
      total += product.price * product.stock;
    }

    return total;
  }
}
