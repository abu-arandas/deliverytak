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
  String? category, brand;

  TextEditingController color = TextEditingController();
  List<ColorModel> colors = [];

  List<String> sizes = [];

  Genders? gender;
  int? stock;

  @override
  Widget build(BuildContext context) => AdminScaffold(
        pageName: 'Shop',
        body: Form(
          key: formKey,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
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
                        for (var element in imageProviders) ...{
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.5),
                                image: DecorationImage(
                                  image: element,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () => setState(() {
                                  imageProviders.remove(element);
                                }),
                                icon: const Icon(Icons.remove_circle),
                              ),
                            ),
                          ),
                        }
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
                    child: StreamBuilder(
                      stream: categories(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.all(8).copyWith(top: 0),
                                child: Text(
                                  'Category',
                                  style: Theme.of(context)
                                      .inputDecorationTheme
                                      .labelStyle!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              FB5Row(
                                children: List.generate(
                                  snapshot.data!.length,
                                  (index) => FB5Col(
                                    classNames:
                                        'col-lg-3 col-md-4 col-sm-6 col-xs-6',
                                    child: ListTile(
                                      onTap: () => setState(() =>
                                          category = snapshot.data![index].id),
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side:
                                            category == snapshot.data![index].id
                                                ? const BorderSide(
                                                    width: 0.5,
                                                    color: Colors.black,
                                                  )
                                                : BorderSide.none,
                                      ),
                                      title: Text(
                                        snapshot.data![index].name,
                                        style: Theme.of(context)
                                            .inputDecorationTheme
                                            .labelStyle,
                                      ),
                                      trailing:
                                          category == snapshot.data![index].id
                                              ? IconButton(
                                                  onPressed: () => setState(
                                                      () => category = null),
                                                  icon: const Icon(Icons.close),
                                                )
                                              : null,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
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

                  // Brand
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: StreamBuilder(
                      stream: brands(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.all(8).copyWith(top: 0),
                                child: Text(
                                  'Brand',
                                  style: Theme.of(context)
                                      .inputDecorationTheme
                                      .labelStyle!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              FB5Row(
                                children: List.generate(
                                  snapshot.data!.length,
                                  (index) => FB5Col(
                                    classNames:
                                        'col-lg-3 col-md-4 col-sm-6 col-xs-6',
                                    child: ListTile(
                                      onTap: () => setState(() =>
                                          brand = snapshot.data![index].id),
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: brand == snapshot.data![index].id
                                            ? const BorderSide(
                                                width: 0.5,
                                                color: Colors.black,
                                              )
                                            : BorderSide.none,
                                      ),
                                      title: Text(
                                        snapshot.data![index].name,
                                        style: Theme.of(context)
                                            .inputDecorationTheme
                                            .labelStyle,
                                      ),
                                      trailing: brand ==
                                              snapshot.data![index].id
                                          ? IconButton(
                                              onPressed: () =>
                                                  setState(() => brand = null),
                                              icon: const Icon(Icons.close),
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
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

                  // Colors & Sizes
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: FB5Row(
                      children: [
                        // Colors
                        FB5Col(
                          classNames: 'col-6',
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Colors',
                                prefixIcon: IconButton(
                                  onPressed: () {}, // TODO Color Picker
                                  icon: const Icon(Icons.circle),
                                ),
                              ),
                              controller: color,
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
                        ),

                        // Sizes
                        FB5Col(
                          classNames: 'col-6',
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Sizes'),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* required';
                                } else {
                                  return null;
                                }
                              },
                              onFieldSubmitted: (value) => setState(() {
                                if (!sizes.contains(value)) {
                                  sizes.add(value);
                                }

                                value = value;
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gender
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8).copyWith(top: 0),
                          child: Text(
                            'Gender',
                            style: Theme.of(context)
                                .inputDecorationTheme
                                .labelStyle!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        FB5Row(
                          children: List.generate(
                            Genders.values.length,
                            (index) => FB5Col(
                              classNames: 'col-lg-3 col-md-4 col-sm-6 col-xs-6',
                              child: ListTile(
                                onTap: () => setState(
                                    () => gender = Genders.values[index]),
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: gender == Genders.values[index]
                                      ? const BorderSide(
                                          width: 0.5,
                                          color: Colors.black,
                                        )
                                      : BorderSide.none,
                                ),
                                title: Text(
                                  genders.reverse[Genders.values[index]]!,
                                  style: Theme.of(context)
                                      .inputDecorationTheme
                                      .labelStyle,
                                ),
                                trailing: gender == Genders.values[index]
                                    ? IconButton(
                                        onPressed: () =>
                                            setState(() => gender = null),
                                        icon: const Icon(Icons.close),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stock
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          setState(() {
                            stock = int.parse(value);
                          });
                        }

                        if (value.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) => validate(),
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
      if (pickedImage != null &&
          category != null &&
          gender != null &&
          stock != null) {
        try {
          // Storage
          FirebaseStorage.instance
              .ref('products/${name.text.toUpperCase()}/')
              .child('main')
              .putData(
                await pickedImage!.readAsBytes(),
              )

              // Image url
              .then(
                (value) => value.ref
                    .getDownloadURL()

                    // Images
                    .then((image) async {
                  List<TaskSnapshot> refs = [];

                  for (var i = 0; i < pickedImages.length; i++) {
                    Uint8List image = await pickedImages[i]!.readAsBytes();

                    FirebaseStorage.instance
                        .ref('products/${name.text.toUpperCase()}/')
                        .child(
                          i.toString(),
                        )
                        .putData(image)
                        .then(
                          (p0) => refs.add(p0),
                        );
                  }

                  return {
                    'mainImage': image,
                    'refs': refs,
                  };
                }).then(
                  (value) => productsCollection.doc().set(
                        ProductModel(
                          id: '',
                          name: name.text,
                          image: value['mainImage'].toString(),
                          price: double.parse(price.text),
                          category: category!,
                          description: description.text,
                          colors: colors,
                          sizes: sizes,
                          images: value['refs'] as List<String>,
                          gender: gender!,
                          stock: stock!,
                        ).toJson(),
                      ),
                ),
              )

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
