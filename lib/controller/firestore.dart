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
Stream<UserModel> singleUser(id) => usersCollection
    .doc(id)
    .snapshots()
    .map((query) => UserModel.fromJson(query));

Stream<List<BrandModel>> brands() => brandsCollection.snapshots().map(
      (query) => query.docs.map((item) => BrandModel.fromDoc(item)).toList(),
    );
Stream<BrandModel> brand(id) => brandsCollection
    .doc(id)
    .snapshots()
    .map((query) => BrandModel.fromDoc(query));

Stream<List<CategoryModel>> categories() =>
    categoriesCollection.snapshots().map((query) =>
        query.docs.map((item) => CategoryModel.fromDoc(item)).toList());
Stream<CategoryModel> category(id) => categoriesCollection
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
    for (ProductModel product in order.products) {
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

List<ProductModel> initialProducts = [
  ProductModel(
    id: '',
    name: 'STRIPED OVERSIZE SHIRT',
    image:
        'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FSTRIPED%20OVERSIZE%20SHIRT%2FSTRIPED%20OVERSIZE%20SHIRT.jpg?alt=media&token=df05db0f-0519-45f7-8dca-dd7cead1097a',
    price: 59.9,
    category: '6k9or5e98E8MnAzfqUm0',
    description:
        'Oversized fit shirt. Italian collar and short sleeves. Chest patch pocket. Side vents at hem.Front button closure partially hidden by a flap',
    sizes: ['S', 'M', 'L', 'XL'],
    images: [
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FSTRIPED%20OVERSIZE%20SHIRT%2F1.jpg?alt=media&token=15b61b69-e5e3-450b-9719-1fcffb76c7d5',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FSTRIPED%20OVERSIZE%20SHIRT%2F2.jpg?alt=media&token=15b61b69-e5e3-450b-9719-1fcffb76c7d5',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FSTRIPED%20OVERSIZE%20SHIRT%2F3.jpg?alt=media&token=15b61b69-e5e3-450b-9719-1fcffb76c7d5',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FSTRIPED%20OVERSIZE%20SHIRT%2F4.jpg?alt=media&token=15b61b69-e5e3-450b-9719-1fcffb76c7d5',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FSTRIPED%20OVERSIZE%20SHIRT%2F5.jpg?alt=media&token=15b61b69-e5e3-450b-9719-1fcffb76c7d5',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FSTRIPED%20OVERSIZE%20SHIRT%2F6.jpg?alt=media&token=15b61b69-e5e3-450b-9719-1fcffb76c7d5',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FSTRIPED%20OVERSIZE%20SHIRT%2F7.jpg?alt=media&token=15b61b69-e5e3-450b-9719-1fcffb76c7d5',
    ],
    brand: 'FR3mb2P2d045V1Tb0MZB',
    gender: Genders.men,
    stock: 5,
  ),
  ProductModel(
    id: '',
    name: 'FLORAL EMBROIDERED SHIRT',
    image:
        'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FFLORAL%20EMBROIDERED%20SHIRT%2FFLORAL%20EMBROIDERED%20SHIRT.jpg?alt=media&token=c7bbf6e2-c337-429d-86fc-de9aa0d40f00',
    price: 69.9,
    category: '6k9or5e98E8MnAzfqUm0',
    description:
        'Relaxed fit shirt made of cotton and linen blend fabric. Italian collar and short sleeves. All over embroidered tonal cord. Front button closure',
    sizes: ['S', 'M', 'L', 'XL'],
    images: [
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FFLORAL%20EMBROIDERED%20SHIRT%2F1.jpg?alt=media&token=756f3bf3-6d73-408e-8761-b54c6acc6465',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FFLORAL%20EMBROIDERED%20SHIRT%2F2.jpg?alt=media&token=756f3bf3-6d73-408e-8761-b54c6acc6465',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FFLORAL%20EMBROIDERED%20SHIRT%2F3.jpg?alt=media&token=756f3bf3-6d73-408e-8761-b54c6acc6465',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FFLORAL%20EMBROIDERED%20SHIRT%2F4.jpg?alt=media&token=756f3bf3-6d73-408e-8761-b54c6acc6465',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FFLORAL%20EMBROIDERED%20SHIRT%2F5.jpg?alt=media&token=756f3bf3-6d73-408e-8761-b54c6acc6465',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FFLORAL%20EMBROIDERED%20SHIRT%2F6.jpg?alt=media&token=756f3bf3-6d73-408e-8761-b54c6acc6465',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FFLORAL%20EMBROIDERED%20SHIRT%2F7.jpg?alt=media&token=756f3bf3-6d73-408e-8761-b54c6acc6465',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FFLORAL%20EMBROIDERED%20SHIRT%2F8.jpg?alt=media&token=756f3bf3-6d73-408e-8761-b54c6acc6465',
    ],
    brand: 'FR3mb2P2d045V1Tb0MZB',
    gender: Genders.men,
    stock: 5,
  ),
  ProductModel(
    id: '',
    name: 'TAPERED PANTS',
    image:
        'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2FTAPERED%20PANTS.jpg?alt=media&token=af35491b-44ff-48ac-a42b-dd5b5ec2040d',
    price: 49.9,
    category: 'Kg5mbNAybYwUUaOBrFxJ',
    description:
        'Tapered pants made of cotton and linen blend fabric. Adjustable elastic drawstring waistband. Front pockets and back patch pockets. Front zip and button closure',
    sizes: ['S', 'M', 'L', 'XL'],
    images: [
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F1.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F2.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F3.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F4.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F5.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F6.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F7.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F8.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F9.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F10.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F11.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F12.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F13.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F14.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F15.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F16.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F17.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F18.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F19.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F20.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F21.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F22.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F23.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F24.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F25.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F26.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F27.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F28.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F29.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTAPERED%20PANTS%2F30.jpg?alt=media&token=21e722bc-233c-47d3-b5db-11f780e5be57',
    ],
    brand: 'FR3mb2P2d045V1Tb0MZB',
    gender: Genders.men,
    stock: 5,
  ),
  ProductModel(
    id: '',
    name: 'TUXEDO JACKET',
    image:
        'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTUXEDO%20JACKET%2FTUXEDO%20JACKET.jpg?alt=media&token=505a075a-8b20-4b17-b233-c2e9ddb30809',
    price: 99.9,
    category: '7TaIUuGpfiZOrsJJxZnq',
    description:
        'Blazer with satin effect lapel collar and long sleeves with shoulder pads. Front flap pockets. Fitted waist. Front button closure',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    images: [
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTUXEDO%20JACKET%2F1.jpg?alt=media&token=4177321e-c119-46d5-865b-905823830740',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTUXEDO%20JACKET%2F2.jpg?alt=media&token=4177321e-c119-46d5-865b-905823830740',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTUXEDO%20JACKET%2F3.jpg?alt=media&token=4177321e-c119-46d5-865b-905823830740',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTUXEDO%20JACKET%2F4.jpg?alt=media&token=4177321e-c119-46d5-865b-905823830740',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTUXEDO%20JACKET%2F5.jpg?alt=media&token=4177321e-c119-46d5-865b-905823830740',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTUXEDO%20JACKET%2F6.jpg?alt=media&token=4177321e-c119-46d5-865b-905823830740',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FTUXEDO%20JACKET%2F7.jpg?alt=media&token=4177321e-c119-46d5-865b-905823830740',
    ],
    brand: 'FR3mb2P2d045V1Tb0MZB',
    gender: Genders.women,
    stock: 5,
  ),
  ProductModel(
    id: '',
    name: 'ZW COLLECTION EMBROIDERED SHIRTDRESS',
    image:
        'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS.jpg?alt=media&token=be7ab674-b633-4ebb-9bab-4d0442097d4f',
    price: 129.9,
    category: 'lmQbK7Mjtj9DhDdRGLQZ',
    description:
        'Midi dress made of 100% cotton. Lapel collar and below-the-elbow length sleeves with cuffs. Adjustable self belt with lined buckle. Embroidered eyelet detail. Tonal interior lining. Front hidden button closure',
    sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
    images: [
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F1.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F2.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F3.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F4.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F5.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F6.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F7.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F8.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F9.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20EMBROIDERED%20SHIRTDRESS%2F10.jpg?alt=media&token=8a101a42-9192-4c50-b34e-03741a5129e1',
    ],
    brand: 'FR3mb2P2d045V1Tb0MZB',
    gender: Genders.women,
    stock: 5,
  ),
  ProductModel(
    id: '',
    name: 'ZW COLLECTION BELTED WRINKLED DRESS',
    image:
        'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS.jpg?alt=media&token=ea90a5ae-b527-4499-8941-7a2c96b3956d',
    price: 89.9,
    category: 'lmQbK7Mjtj9DhDdRGLQZ',
    description:
        'Midi dress made of 100% cotton. V-neckline and dropped short sleeves. Adjustable tied self belt. Wrinkled fabric and pronounced tonal topstitching. Front button closure',
    sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
    images: [
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F1.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F2.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F3.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F4.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F5.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F6.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F7.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F8.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F9.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F10.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F11.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F12.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F13.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F14.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F15.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F16.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F17.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F18.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F19.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/products%2FZW%20COLLECTION%20BELTED%20WRINKLED%20DRESS%2F20.jpg?alt=media&token=61c6f4f7-eac2-4e55-95fe-b0cd072c7d17',
    ],
    brand: 'FR3mb2P2d045V1Tb0MZB',
    gender: Genders.women,
    stock: 5,
  ),
];
