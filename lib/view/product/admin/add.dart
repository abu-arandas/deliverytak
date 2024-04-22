// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> formKey = GlobalKey();

  XFile? pickedImage;
  ImageProvider imageProvider = NetworkImage(noImage);
  List<XFile?> pickedImages = [];
  List<ImageProvider> imageProviders = [];

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController stock = TextEditingController();

  TextEditingController size = TextEditingController();
  List<String> sizes = [];

  @override
  Widget build(BuildContext context) => AdminScaffold(
        pageName: 'Shop',
        body: Form(
          key: formKey,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: double.maxFinite,
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12.5),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () async => await ImagePicker()
                          .pickImage(source: ImageSource.gallery)
                          .then((value) async {
                        pickedImage = value;

                        if (value != null) {
                          imageProvider = MemoryImage(
                            await value.readAsBytes(),
                          );
                        }

                        setState(() {});
                      }),
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Images
                  SizedBox(
                    width: double.maxFinite,
                    height: 100,
                    child: Row(
                      children: [
                        // Add
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Colors.transparent.withOpacity(0.5),
                            ),
                            child: IconButton(
                              onPressed: () async => await ImagePicker()
                                  .pickImage(source: ImageSource.gallery)
                                  .then((value) async {
                                pickedImages.add(value);

                                if (value != null) {
                                  imageProviders.add(
                                    MemoryImage(
                                      await value.readAsBytes(),
                                    ),
                                  );
                                }

                                setState(() {});
                              }),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Images
                        Expanded(
                          child: Row(
                            children: List.generate(
                              imageProviders.length,
                              (index) => AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.5),
                                    image: DecorationImage(
                                      image: imageProviders[index],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () => setState(() {
                                      imageProviders.removeAt(index);
                                    }),
                                    icon: const Icon(Icons.remove_circle),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Name
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      controller: name,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  // Price
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Price'),
                      controller: price,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      controller: description,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      minLines: 1,
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  // Category
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        suffixIcon: StreamBuilder(
                          stream: categories(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    List.generate(
                                  snapshot.data!.length,
                                  (index) => PopupMenuItem(
                                    onTap: () => setState(
                                      () => category = TextEditingController(
                                        text: snapshot.data![index].id,
                                      ),
                                    ),
                                    value: snapshot.data![index].id,
                                    child: Text(snapshot.data![index].name),
                                  ),
                                ),
                                child: const Icon(Icons.keyboard_arrow_down),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                snapshot.error.toString(),
                              ));
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      controller: category,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  // Brand
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Brand',
                        suffixIcon: StreamBuilder(
                          stream: brands(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    List.generate(
                                  snapshot.data!.length,
                                  (index) => PopupMenuItem(
                                    onTap: () => setState(
                                      () => brand = TextEditingController(
                                        text: snapshot.data![index].id,
                                      ),
                                    ),
                                    value: snapshot.data![index].id,
                                    child: Text(snapshot.data![index].name),
                                  ),
                                ),
                                child: const Icon(Icons.keyboard_arrow_down),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                snapshot.error.toString(),
                              ));
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      controller: category,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  // Gender
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        suffixIcon: PopupMenuButton(
                          itemBuilder: (BuildContext context) => List.generate(
                            Genders.values.length,
                            (index) => PopupMenuItem(
                              onTap: () => setState(
                                () => gender = TextEditingController(
                                  text: genders.reverse[Genders.values[index]],
                                ),
                              ),
                              value: Genders.values[index],
                              child: Text(
                                genders.reverse[Genders.values[index]]!,
                              ),
                            ),
                          ),
                          child: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                      controller: category,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  // Stock
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: stock,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) => validate(),
                    ),
                  ),

                  // Sizes
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Sizes',
                                style: Theme.of(context)
                                    .inputDecorationTheme
                                    .labelStyle!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton.outlined(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Product sizes'),
                                  content: Wrap(
                                    children: List.generate(
                                      sizes.length,
                                      (index) => Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        padding: const EdgeInsets.only(left: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(sizes[index]),
                                            IconButton(
                                              onPressed: () =>
                                                  sizes.removeAt(index),
                                              icon: const Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextFormField(
                                      controller: size,
                                      decoration: const InputDecoration(
                                          labelText: 'Size'),
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return '* required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          if (!sizes.contains(value)) {
                                            sizes.add(value);
                                          }

                                          size = TextEditingController();
                                        });

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        Wrap(
                          children: List.generate(
                            sizes.length,
                            (index) => Container(
                              margin: const EdgeInsets.only(
                                right: 4,
                                bottom: 4,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(sizes[index]),
                                  ),
                                  InkWell(
                                    onTap: () => sizes.removeAt(index),
                                    child: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Button
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () => validate(),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                      ),
                      child: const Text('finish'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void validate() async {
    if (formKey.currentState!.validate()) {
      if (pickedImage != null) {
        try {
          const chars =
              'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
          Random rnd = Random();

          String getRandomString() => String.fromCharCodes(
                Iterable.generate(
                    15, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
              );

          ProductModel product = ProductModel(
            id: '',
            name: name.text,
            image: '',
            price: double.parse(price.text),
            category: category.text,
            description: description.text,
            sizes: sizes,
            images: [],
            gender: genders.map[gender.text]!,
            stock: int.parse(stock.text),
          );

          // Firestore
          productsCollection
              .doc(getRandomString())
              .set(product.toJson())

              // Storage
              .then((value) async => FirebaseStorage.instance
                  .ref('products/${getRandomString()}/')
                  .child('main')
                  .putData(await pickedImage!.readAsBytes()))

              // Image url
              .then((value) => value.ref.getDownloadURL())

              // Images
              .then((image) async {
                List<String> refs = [];

                for (var i = 0; i < pickedImages.length; i++) {
                  Uint8List image = await pickedImages[i]!.readAsBytes();

                  FirebaseStorage.instance
                      .ref('products/${getRandomString()}/')
                      .child(i.toString())
                      .putData(image)
                      .then((p0) async {
                    String link = await p0.ref.getDownloadURL();

                    refs.add(link);
                  });
                }

                return {'mainImage': image, 'refs': refs};
              })

              // Update Images
              .then((value) =>
                  productsCollection.doc(getRandomString()).update(product
                      .copyWith(
                        image: value['mainImage'].toString(),
                        images: value['refs'] as List<String>,
                      )
                      .toJson()))

              // Exit
              .then((value) {
                Navigator.pop(context);

                succesSnackBar(context, 'Added');
              });
        } catch (error) {
          errorSnackBar(
            context,
            error.toString(),
          );
        }
      } else {
        errorSnackBar(context, 'Please add the Main image');
      }
    }
  }
}
