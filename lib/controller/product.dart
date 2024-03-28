import '/exports.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();

  CollectionReference<Map<String, dynamic>> productsCollection =
      FirebaseFirestore.instance.collection('products');

  /* ====== Read ====== */
  Stream<List<ProductModel>> products() => productsCollection.snapshots().map(
      (query) => query.docs.map((item) => ProductModel.fromDoc(item)).toList());

  Stream<ProductModel> singleProduct(id) => productsCollection
      .doc(id)
      .snapshots()
      .map((query) => ProductModel.fromDoc(query));

  List<ProductModel> bestSeller(
      List<OrderModel> orders, List<ProductModel> products) {
    List<String> productsId = [];

    for (OrderModel order in orders) {
      for (ProductModel product in order.products) {
        if (!productsId.contains(product.id)) {
          productsId.add(product.id);
        }
      }
    }

    List<ProductModel> data = products
        .where((element) =>
            productsId.length < 4 ? true : productsId.contains(element.id))
        .toList();

    return List.generate(
      data.length >= 4 ? 4 : data.length,
      (index) => data[index],
    );
  }

  Stream<List<ProductModel>> categoryProducts(ProductModel product) =>
      productsCollection.snapshots().map((query) => query.docs
          .map((item) => ProductModel.fromDoc(item))
          .where((element) => element.brandName == product.brandName)
          .toList());

  /* ====== Favorite ====== */
  List<String> favoriteProducts = <String>[];

  void getFavoriteProducts() {
    List list = GetStorage().read('favoriteProducts') ?? [];
    favoriteProducts =
        List.generate(list.length, (index) => list[index].toString());

    update();
  }

  Widget favoriteButton({required String id, Color? color}) =>
      GetBuilder<ProductController>(
        init: ProductController(),
        builder: (controller) => favoriteProducts.contains(id)
            ? IconButton(
                onPressed: () {
                  favoriteProducts.removeWhere((element) => element == id);

                  GetStorage().write('favoriteProducts', favoriteProducts);

                  update();
                },
                icon: Icon(
                  Icons.favorite,
                  color: Theme.of(Get.context!).colorScheme.error,
                ),
              )
            : IconButton(
                onPressed: () {
                  favoriteProducts.add(id);

                  GetStorage().write('favoriteProducts', favoriteProducts);

                  update();
                },
                icon: Icon(Icons.favorite_border, color: color),
              ),
      );

  /* ====== Cart ====== */
  RxList<ProductModel> cartProducts = <ProductModel>[].obs;

  Widget cartButton({required String id, Color? color}) => StreamBuilder(
        stream: singleProduct(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GetBuilder<ProductController>(
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
                    if (exists)
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
                        icon: Icon(Icons.remove, color: color),
                      ),

                    // Count
                    if (exists)
                      Text(
                        count.toString(),
                        style: TextStyle(color: color),
                      ),

                    // Add
                    if (snapshot.data!.stock >= count)
                      IconButton(
                        onPressed: () {
                          if (exists) {
                            controller.cartProducts
                                .singleWhere((element) => element.id == id)
                                .stock++;
                          } else {
                            controller.cartProducts.add(
                              ProductModel(
                                id: id,
                                name: snapshot.data!.name,
                                price: snapshot.data!.price,
                                brandName: snapshot.data!.brandName,
                                imageUrl: snapshot.data!.imageUrl,
                                additionalImageUrls:
                                    snapshot.data!.additionalImageUrls,
                                stock: 1,
                              ),
                            );
                          }

                          controller.update();
                        },
                        icon: Icon(exists ? Icons.add : Icons.shopping_cart,
                            color: color),
                      ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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

  @override
  void onInit() {
    super.onInit();

    getFavoriteProducts();
  }
}
