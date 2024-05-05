import '/exports.dart';

/* ====== Collections ====== */
CollectionReference<Map<String, dynamic>> usersCollection =
    FirebaseFirestore.instance.collection('users');
CollectionReference<Map<String, dynamic>> brandsCollection =
    FirebaseFirestore.instance.collection('brands');
CollectionReference<Map<String, dynamic>> categoriesCollection =
    FirebaseFirestore.instance.collection('categories');
CollectionReference<Map<String, dynamic>> productsCollection =
    FirebaseFirestore.instance.collection('products');
CollectionReference<Map<String, dynamic>> ordersCollection =
    FirebaseFirestore.instance.collection('orders');

/* ====== Read ====== */
Stream<List<UserModel>> users() => usersCollection.snapshots().map(
    (query) => query.docs.map((item) => UserModel.fromJson(item)).toList());
Stream<List<UserModel>> drivers() =>
    usersCollection.snapshots().map((query) => query.docs
        .map((item) => UserModel.fromJson(item))
        .where((element) => element.role == UserRole.driver)
        .toList());
Stream<UserModel> singleUser(id) => usersCollection
    .doc(id)
    .snapshots()
    .map((query) => UserModel.fromJson(query));

Stream<List<BrandModel>> brands() => brandsCollection.snapshots().map(
      (query) => query.docs.map((item) => BrandModel.fromDoc(item)).toList(),
    );
Stream<BrandModel> singleBrand(id) => brandsCollection
    .doc(id)
    .snapshots()
    .map((query) => BrandModel.fromDoc(query));

Stream<List<CategoryModel>> categories() =>
    categoriesCollection.snapshots().map((query) =>
        query.docs.map((item) => CategoryModel.fromDoc(item)).toList());
Stream<CategoryModel> singleCategory(id) => categoriesCollection
    .doc(id)
    .snapshots()
    .map((query) => CategoryModel.fromDoc(query));

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
    for (CartModel product in order.products) {
      if (!productsId.contains(product.id)) {
        productsId.add(product.id);
      }
    }
  }

  List<ProductModel> data = products
      .where((element) =>
          productsId.length < 3 ? true : productsId.contains(element.id))
      .toList();

  return List.generate(
      data.length >= 3 ? 3 : data.length, (index) => data[index]);
}

Stream<List<ProductModel>> relatedProducts(ProductModel product) =>
    productsCollection.snapshots().map((query) => query.docs
        .map((item) => ProductModel.fromDoc(item))
        .where((element) =>
            element.id != product.id &&
            (element.category == product.category ||
                element.brand == product.brand))
        .toList());

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
