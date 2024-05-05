// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

class EditProduct extends StatefulWidget {
  final String id;
  const EditProduct({super.key, required this.id});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  GlobalKey<FormState> formKey = GlobalKey();

  List<XFile> images = [];
  List<ImageProvider> imagesProviders = [];

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  CategoryModel? category;
  BrandModel? brand;
  Genders? gender;
  TextEditingController stock = TextEditingController();

  TextEditingController size = TextEditingController();
  List<String> sizes = [];
  List<Color> colors = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();

    singleProduct(widget.id).listen((event) {
      imagesProviders = event.images.map((e) => NetworkImage(e)).toList();

      name = TextEditingController(text: event.name);
      price = TextEditingController(text: event.price.toString());
      description = TextEditingController(text: event.description);

      if (event.category != null) {
        singleCategory(event.category).listen((event) {
          category = event;
          setState(() {});
        });
      }

      if (event.brand != null) {
        singleBrand(event.category).listen((event) {
          brand = event;
          setState(() {});
        });
      }

      gender = event.gender;
      stock = TextEditingController(text: event.stock.toString());

      sizes = event.sizes;
      colors = event.colors;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => AdminScaffold(
        pageName: 'Shop',
        body: FB5Row(
          children: [
            // Images
            FB5Col(
              classNames: 'col-lg-7 col-md-6 col-sm-12 col-xs-12',
              child: FB5Row(
                children: [
                  // Title
                  FB5Col(
                    classNames: 'col-12 px-3',
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title: const Text(
                        'Images',
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(Icons.add),
                      onTap: () => ImagePicker()
                          .pickMultiImage()
                          .then((value) async => value)
                          .then((value) => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: List.generate(
                                      colors.length,
                                      (index) => Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            for (var i = 0;
                                                i < value.length;
                                                i++) {
                                              imagesProviders.add(
                                                MemoryImage(await value[i]
                                                    .readAsBytes()),
                                              );

                                              images.add(value[i]);

                                              if (i == 0) {
                                                images.add(XFile(
                                                  value[i].path,
                                                  name:
                                                      '${ColorTools.nameThatColor(colors[index])} - main',
                                                ));
                                              } else {
                                                images.add(XFile(
                                                  value[i].path,
                                                  name:
                                                      '${ColorTools.nameThatColor(colors[index])} - $i',
                                                ));
                                              }
                                            }

                                            setState(() {});

                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: colors[index],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                ColorTools.nameThatColor(
                                                    colors[index]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  ),

                  // Images
                  FB5Col(
                    classNames: 'col-12 p-3',
                    child: FB5Row(
                      children: List.generate(
                        imagesProviders.length,
                        (index) => FB5Col(
                          classNames: 'col-lg-3 col-md-4 col-sm-6 col-xs-6',
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imagesProviders[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: IconButton.outlined(
                                onPressed: () {
                                  images.removeAt(index);
                                  imagesProviders.removeAt(index);
                                  setState(() {});
                                },
                                style: IconButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                  foregroundColor: Colors.red,
                                ),
                                icon: const Icon(Icons.remove),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Informations
            FB5Col(
              classNames: 'col-lg-5 col-md-6 col-sm-12 col-xs-12',
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        maxLines: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    // Sizes
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Product sizes'),
                            content: SizedBox(
                              width: 500,
                              child: Wrap(
                                children: List.generate(
                                  sizes.length,
                                  (index) => Container(
                                    margin: const EdgeInsets.only(right: 4),
                                    padding: const EdgeInsets.only(left: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(sizes[index]),
                                        IconButton(
                                          onPressed: () => setState(() {
                                            sizes.removeAt(index);
                                          }),
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              TextFormField(
                                controller: size,
                                decoration:
                                    const InputDecoration(labelText: 'Size'),
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
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (!sizes.contains(size.text) &&
                                        size.text.isNotEmpty) {
                                      sizes.add(size.text);
                                    }

                                    size = TextEditingController();
                                  });
                                },
                                child: const Text('add'),
                              ),
                            ],
                          ),
                        ),
                        title: const Text(
                          'Sizes',
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        subtitle: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            sizes.length,
                            (index) => Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(sizes[index]),
                                  IconButton(
                                    onPressed: () => setState(() {
                                      sizes.removeAt(index);
                                    }),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Colors
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onTap: () {
                          Color color = Theme.of(context).colorScheme.primary;

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Add a new Color'),
                              content: SizedBox(
                                width: 500,
                                child: ColorPicker(
                                  color: color,
                                  onColorChanged: (value) =>
                                      setState(() => color = value),
                                  showColorName: true,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    colors.add(color);

                                    setState(() {});

                                    Navigator.pop(context);
                                  },
                                  child: const Text('add'),
                                ),
                              ],
                            ),
                          );
                        },
                        title: const Text(
                          'Colors',
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        subtitle: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            colors.length,
                            (index) => Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: colors[index],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(ColorTools.nameThatColor(colors[index])),
                                  IconButton(
                                    onPressed: () => setState(() {
                                      colors.removeAt(index);
                                    }),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Category
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: StreamBuilder(
                        stream: categories(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return PopupMenuButton(
                              itemBuilder: (BuildContext context) =>
                                  List.generate(
                                snapshot.data!.length,
                                (index) => PopupMenuItem(
                                  onTap: () => setState(
                                    () => category = snapshot.data![index],
                                  ),
                                  value: snapshot.data![index].id,
                                  child: Text(snapshot.data![index].name),
                                ),
                              ),
                              child: ListTile(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                leading: category != null
                                    ? CachedNetworkImage(
                                        imageUrl: category!.image,
                                        width: 75,
                                        height: 50,
                                      )
                                    : null,
                                title: const Text(
                                  'Category',
                                  style: TextStyle(fontSize: 14),
                                ),
                                trailing:
                                    const Icon(Icons.keyboard_arrow_right),
                                subtitle: category != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(category!.name),
                                      )
                                    : null,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
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
                            return PopupMenuButton(
                              itemBuilder: (BuildContext context) =>
                                  List.generate(
                                snapshot.data!.length,
                                (index) => PopupMenuItem(
                                  onTap: () => setState(
                                    () => brand = snapshot.data![index],
                                  ),
                                  value: snapshot.data![index].id,
                                  child: Text(snapshot.data![index].name),
                                ),
                              ),
                              child: ListTile(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                leading: brand != null
                                    ? CachedNetworkImage(
                                        imageUrl: brand!.image,
                                        width: 75,
                                        height: 50,
                                      )
                                    : null,
                                title: const Text(
                                  'Brand',
                                  style: TextStyle(fontSize: 14),
                                ),
                                trailing:
                                    const Icon(Icons.keyboard_arrow_right),
                                subtitle: brand != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(brand!.name),
                                      )
                                    : null,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
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

                    // Gender
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: PopupMenuButton(
                        itemBuilder: (BuildContext context) => List.generate(
                          Genders.values.length,
                          (index) => PopupMenuItem(
                            onTap: () => setState(
                              () => gender = Genders.values[index],
                            ),
                            value: Genders.values[index],
                            child:
                                Text(genders.reverse[Genders.values[index]]!),
                          ),
                        ),
                        child: ListTile(
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          title: const Text(
                            'Gender',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          subtitle: gender != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    genders.reverse[gender]!,
                                  ),
                                )
                              : null,
                        ),
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

                    // Button
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              try {
                                productsCollection.doc(widget.id).delete();

                                FirebaseStorage.instance
                                    .ref('products/${widget.id}/')
                                    .delete();

                                Navigator.pop(context);
                                succesSnackBar(context, 'deleted');
                              } catch (error) {
                                errorSnackBar(context, error.toString());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(200, 50),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('delete'),
                          ),
                          ElevatedButton(
                            onPressed: () => validate(),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(200, 50),
                            ),
                            child: loading
                                ? const CircularProgressIndicator()
                                : const Text('finish'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  void validate() {
    setState(() => loading = true);

    if (formKey.currentState!.validate()) {
      try {
        ProductModel product = ProductModel(
          id: widget.id,
          name: name.text,
          price: double.parse(price.text),
          description: description.text,
          images: [],
          category: category?.id,
          brand: brand?.id,
          sizes: sizes,
          colors: colors,
          gender: gender,
          stock: int.parse(stock.text),
        );

        // Firestore
        productsCollection
            .doc(product.id)
            .update(product.toJson())

            // Storage
            .then((value) async {
          for (var element in colors) {
            List<XFile> colorImages = images
                .where((image) =>
                    image.name.contains(ColorTools.nameThatColor(element)))
                .toList();

            for (var i = 0; i < colorImages.length; i++) {
              String child = i == 0 ? 'main' : i.toString();

              Uint8List image = await colorImages[i].readAsBytes();

              // Upload
              FirebaseStorage.instance
                  .ref(
                      'products/${product.id}/${ColorTools.nameThatColor(element)}/')
                  .child(child)
                  .putData(image)

                  // Get URL
                  .then((ref) async => await ref.ref.getDownloadURL())

                  // Update Product
                  .then((value) => productsCollection.doc(product.id).update(
                        {
                          'images': FieldValue.arrayUnion([value])
                        },
                      ));
            }
          }
        })

            // Exit
            .then((value) {
          setState(() => loading = false);
          Navigator.pop(context);

          succesSnackBar(context, 'Update');
        });
      } catch (error) {
        setState(() => loading = false);

        errorSnackBar(context, error.toString());
      }
    } else {
      setState(() => loading = false);
    }
  }
}
