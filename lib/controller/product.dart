// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

CollectionReference<Map<String, dynamic>> productsCollection =
    FirebaseFirestore.instance.collection('products');

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
    data.length >= 3 ? 3 : data.length,
    (index) => data[index],
  );
}

Stream<List<ProductModel>> relatedProducts(ProductModel product) =>
    productsCollection.snapshots().map((query) => query.docs
        .map((item) => ProductModel.fromDoc(item))
        .where((element) =>
            element.id != product.id &&
            (element.category == product.category ||
                element.brand == product.brand))
        .toList());

void addProduct({
  required BuildContext context,
  required String name,
  required double price,
  required String description,
  required List<XFile> images,
  required List<String> sizes,
  required List<Color> colors,
  required String category,
  required String brand,
  required Genders gender,
  required int stock,
}) async {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  String id = String.fromCharCodes(Iterable.generate(
    15,
    (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
  ));

  try {
    await productsCollection.doc(id).set(ProductModel(
          id: id,
          name: name,
          price: price,
          description: description,
          images: [],
          sizes: sizes,
          colors: colors,
          category: category,
          brand: brand,
          gender: gender,
          stock: stock,
        ).toJson());

    for (var element in colors) {
      List<XFile> colorImages = images
          .where(
              (image) => image.name.contains(ColorTools.nameThatColor(element)))
          .toList();

      for (var i = 0; i < colorImages.length; i++) {
        String child = i == 0 ? 'main' : i.toString();

        Uint8List image = await colorImages[i].readAsBytes();

        FirebaseStorage.instance
            .ref('products/$id/${ColorTools.nameThatColor(element)}/')
            .child(child)
            .putData(image)
            .then((ref) async => await ref.ref.getDownloadURL())
            .then((value) => productsCollection.doc(id).update({
                  'images': FieldValue.arrayUnion([value])
                }));
      }
    }

    page(context: context, page: const Main());
    succesSnackBar(context, 'Added');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void updateProduct({
  required BuildContext context,
  required String id,
  required String name,
  required double price,
  required String description,
  required List<XFile> images,
  required List<String> sizes,
  required List<Color> colors,
  required String category,
  required String brand,
  required Genders gender,
  required int stock,
}) async {
  try {
    await productsCollection.doc(id).update(ProductModel(
          id: id,
          name: name,
          price: price,
          description: description,
          images: [],
          sizes: sizes,
          colors: colors,
          category: category,
          brand: brand,
          gender: gender,
          stock: stock,
        ).toJson());

    for (var element in colors) {
      // TODO
      List<XFile> colorImages = images
          .where(
              (image) => image.name.contains(ColorTools.nameThatColor(element)))
          .toList();

      for (var i = 0; i < colorImages.length; i++) {
        String child = i == 0 ? 'main' : i.toString();

        Uint8List image = await colorImages[i].readAsBytes();

        FirebaseStorage.instance
            .ref('products/$id/${ColorTools.nameThatColor(element)}/')
            .child(child)
            .putData(image)
            .then((ref) async => await ref.ref.getDownloadURL())
            .then((value) => productsCollection.doc(id).update({
                  'images': FieldValue.arrayUnion([value])
                }));
      }
    }

    page(context: context, page: const Main());
    succesSnackBar(context, 'Updated');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void deleteProduct({required BuildContext context, required String id}) async {
  try {
    await productsCollection.doc(id).delete();
    await FirebaseStorage.instance.ref('products/$id/').delete();

    page(context: context, page: const Main());
    succesSnackBar(context, 'Deleted');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}
