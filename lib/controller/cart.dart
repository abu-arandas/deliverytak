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

  double cartPrice() {
    double total = 0;

    for (var product in cartProducts) {
      total += product.price * product.stock;
    }

    return total;
  }
}
