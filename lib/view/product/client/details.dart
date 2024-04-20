import '/exports.dart';

class ProductDetails extends StatefulWidget {
  final String id;
  const ProductDetails({super.key, required this.id});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int count = 0;
  String? size;
  String? color;

  @override
  void initState() {
    super.initState();

    for (var element in CartController.instance.cartProducts) {
      if (widget.id == element.id) {
        setState(() {
          count = element.stock;
          size = element.sizes.first;
          color = element.colors.first.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => ClientScaffold(
        pageName: 'cart',
        body: StreamBuilder(
          stream: singleProduct(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  FB5Row(
                    classNames: 'align-items-end',
                    children: [
                      image(snapshot.data!.image),
                      FB5Col(
                        classNames: 'col-lg-6 col-md-6 col-sm-12',
                        child: FB5Row(
                          children: [
                            title(snapshot.data!.name),
                            categoryBrand(snapshot.data!),
                            description(snapshot.data!.description),
                            colorsSizes(snapshot.data!),
                            images(snapshot.data!),
                            FB5Col(
                              classNames: 'col-12',
                              child: const SizedBox(height: 48),
                            ),
                            price(snapshot.data!),
                          ],
                        ),
                      ),
                    ],
                  ),
                  relatedProductsWidget(snapshot.data!),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                snapshot.error.toString(),
              ));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          },
        ),
      );

  FB5Col image(String image) => FB5Col(
        classNames: 'col-lg-6 col-md-6 col-sm-12',
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height - 75,
          ),
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.fill,
            width: double.maxFinite,
          ),
        ),
      );

  FB5Col title(String title) => FB5Col(
        classNames: 'col-12 px-3 pt-3',
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );

  FB5Col categoryBrand(ProductModel product) => FB5Col(
        classNames: 'col-12 px-3 pt-3',
        child: Align(
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder(
              stream: category(product.category),
              builder: (context, categorySnapshot) {
                if (categorySnapshot.hasData) {
                  if (product.brand != null) {
                    return StreamBuilder(
                      stream: brand(product.brand),
                      builder: (context, brandSnapshot) {
                        if (brandSnapshot.hasData) {
                          return Text(
                            toTitleCase(
                                '${categorySnapshot.data!.name}  |  ${brandSnapshot.data!.name}'),
                            style: const TextStyle(color: Colors.white),
                          );
                        } else {
                          return Text(
                            toTitleCase(categorySnapshot.data!.name),
                            style: const TextStyle(color: Colors.white),
                          );
                        }
                      },
                    );
                  } else {
                    return Text(
                      toTitleCase(categorySnapshot.data!.name),
                      style: const TextStyle(color: Colors.white),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      );

  FB5Col description(String description) => FB5Col(
        classNames: 'col-12 px-3 pt-3',
        child: Text(
          description,
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
      );

  FB5Col colorsSizes(ProductModel product) => FB5Col(
        classNames: 'col-12 px-3 pt-3',
        child: FB5Row(
          children: [
            // Colors
            FB5Col(
              classNames: 'col-6 p-1',
              child: FB5Row(
                children: List.generate(
                  product.colors.length,
                  (index) => FB5Col(
                    classNames: 'col-lg-6 col-md-6 col-sm-12 p-1',
                    child: ListTile(
                      onTap: () =>
                          setState(() => color = product.colors[index].name),
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: color == product.colors[index].name
                            ? const BorderSide(color: Colors.black)
                            : BorderSide.none,
                      ),
                      leading: Icon(
                        Icons.circle,
                        color: product.colors[index].color,
                      ),
                      title: Text(product.colors[index].name),
                    ),
                  ),
                ),
              ),
            ),

            // Sizes
            FB5Col(
              classNames: 'col-6 p-1',
              child: FB5Row(
                children: List.generate(
                  product.sizes.length,
                  (index) => FB5Col(
                    classNames: 'col-6 p-1',
                    child: ListTile(
                      onTap: () => setState(() => size = product.sizes[index]),
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: size == product.sizes[index]
                            ? const BorderSide(color: Colors.black)
                            : BorderSide.none,
                      ),
                      title: Text(product.sizes[index]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  FB5Col images(ProductModel product) => FB5Col(
        classNames: 'col-12 px-3 pt-3',
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              product.images.length,
              (index) => Container(
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: CachedNetworkImage(
                        imageUrl: product.images[index],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.images[index],
                    fit: BoxFit.fill,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  FB5Col price(ProductModel product) => FB5Col(
        classNames: 'col-12',
        child: Container(
          width: double.maxFinite,
          color: Colors.black,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                product.price.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              GetBuilder<CartController>(
                builder: (controller) {
                  bool exists = controller.cartProducts
                      .any((element) => element.id == product.id);

                  return Row(
                    children: [
                      // Remove
                      if (exists) ...{
                        IconButton(
                          onPressed: () {
                            if (count > 1) {
                              controller.cartProducts
                                  .singleWhere(
                                      (element) => element.id == product.id)
                                  .stock--;
                              controller.update();

                              count--;
                              setState(() {});
                            } else {
                              controller.cartProducts.removeWhere(
                                  (element) => element.id == product.id);
                              controller.update();
                            }
                          },
                          icon: const Icon(Icons.remove, color: Colors.white),
                        )
                      },

                      // Count
                      if (exists) ...{
                        Text(
                          count.toString(),
                          style: const TextStyle(color: Colors.white),
                        )
                      },

                      // Add
                      if (product.stock >= count) ...{
                        IconButton(
                          onPressed: () {
                            if (exists) {
                              ProductModel cartProduct = controller.cartProducts
                                  .singleWhere(
                                      (element) => element.id == product.id);

                              if (color != null) {
                                cartProduct.colors = [
                                  product.colors.singleWhere(
                                      (element) => element.name == color)
                                ];
                              }

                              if (size != null) {
                                cartProduct.sizes = [size!];
                              }

                              cartProduct.stock++;
                            } else {
                              controller.cartProducts.add(
                                product.copyWith(
                                  colors: color != null
                                      ? [
                                          product.colors.singleWhere(
                                              (element) =>
                                                  element.name == color)
                                        ]
                                      : null,
                                  sizes: size != null ? [size!] : null,
                                  stock: 1,
                                ),
                              );
                            }

                            controller.update();
                            count++;
                            setState(() {});
                          },
                          icon: Icon(
                            exists ? Icons.add : Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        )
                      },
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );

  StreamBuilder relatedProductsWidget(ProductModel product) => StreamBuilder(
        stream: relatedProducts(product),
        builder: (context, categoryProductsSnapshot) {
          if (categoryProductsSnapshot.hasData) {
            List<ProductModel> categoryProducts =
                categoryProductsSnapshot.data!.length >= 4
                    ? List.generate(
                        4, (index) => categoryProductsSnapshot.data![index])
                    : categoryProductsSnapshot.data!;

            return FB5Container(
              child: FB5Row(
                classNames: 'pt-3',
                children: List.generate(
                  categoryProducts.length,
                  (index) => FB5Col(
                    classNames: 'col-lg-4 col-md-6 col-12 p-3',
                    child:
                        ClientProductWidget(product: categoryProducts[index]),
                  ),
                ),
              ),
            );
          } else if (categoryProductsSnapshot.hasError) {
            return Center(
                child: Text(
              categoryProductsSnapshot.error.toString(),
            ));
          } else if (categoryProductsSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        },
      );
}
