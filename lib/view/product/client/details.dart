import '/exports.dart';

class ProductDetails extends StatefulWidget {
  final String id;
  const ProductDetails({super.key, required this.id});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int sizeIndex = 0, colorIndex = 0;

  @override
  Widget build(BuildContext context) => ClientScaffold(
        pageName: 'product',
        pageImage: '',
        body: FB5Container(
          child: StreamBuilder(
            stream: singleProduct(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FB5Row(
                  classNames: 'align-items-start',
                  children: [
                    // Images
                    FB5Col(
                      classNames: 'col-lg-8 col-md-6 col-sm-12',
                      child: FB5Row(
                        children: [
                          // Main
                          FB5Col(
                            classNames: 'col-6',
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.images.singleWhere(
                                  (element) =>
                                      element.contains(ColorTools.nameThatColor(
                                              snapshot.data!.colors[colorIndex])
                                          .split(' ')
                                          .first) &&
                                      element.contains('main'),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                          // Secondary
                          for (String image in snapshot.data!.images.where(
                            (element) =>
                                element.contains(ColorTools.nameThatColor(
                                        snapshot.data!.colors[colorIndex])
                                    .split(' ')
                                    .first) &&
                                !element.contains('main'),
                          )) ...{
                            FB5Col(
                              classNames: 'col-6',
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: CachedNetworkImage(
                                  imageUrl: image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          }
                        ],
                      ),
                    ),

                    // Informations
                    FB5Col(
                      classNames: 'col-lg-4 col-md-6 col-sm-12 p-3',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            snapshot.data!.name.toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),

                          // Price
                          Text(
                            '${snapshot.data!.price.toStringAsFixed(2)} JD',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(height: 20),

                          // Description
                          Text(snapshot.data!.description),
                          const SizedBox(height: 16),

                          // Sizes
                          if (snapshot.data!.sizes.isNotEmpty) ...{
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Sizes: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    children: List.generate(
                                      snapshot.data!.sizes.length,
                                      (index) => InkWell(
                                        onTap: () => setState(() {
                                          sizeIndex = index;
                                        }),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 4,
                                            bottom: 4,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: index == sizeIndex
                                                ? Border.all()
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            snapshot.data!.sizes[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          },
                          const SizedBox(height: 16),

                          // Colors
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Colors: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Wrap(
                                  alignment: WrapAlignment.end,
                                  children: List.generate(
                                    snapshot.data!.colors.length,
                                    (index) => InkWell(
                                      onTap: () => setState(() {
                                        colorIndex = index;
                                      }),
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          right: 4,
                                          bottom: 4,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          border: index == colorIndex
                                              ? Border.all()
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color:
                                                  snapshot.data!.colors[index],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              ColorTools.nameThatColor(
                                                  snapshot.data!.colors[index]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Cart
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GetBuilder<CartController>(
                                builder: (controller) => ElevatedButton(
                                  onPressed: () {
                                    controller.cartProducts.add(
                                      CartModel(
                                        id: snapshot.data!.id,
                                        color: colorIndex,
                                        size: sizeIndex,
                                        stock: 1,
                                      ),
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Added to cart'),
                                        content: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: OutlinedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text(
                                                    'Continue Shopping'),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              flex: 2,
                                              child: ElevatedButton(
                                                onPressed: () => page(
                                                  context: context,
                                                  page: const Cart(),
                                                ),
                                                child: const Text('View Cart'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                    controller.update();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(200, 50),
                                  ),
                                  child: const Text('Add to Cart'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              favoriteButton(id: snapshot.data!.id)
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Category
                          StreamBuilder(
                            stream: singleCategory(snapshot.data!.category),
                            builder: (context, categorySnapshot) {
                              if (categorySnapshot.hasData) {
                                return RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Category: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: categorySnapshot.data!.name,
                                      ),
                                    ],
                                  ),
                                );
                              } else if (categorySnapshot.hasError) {
                                return Center(
                                    child: Text(
                                        categorySnapshot.error.toString()));
                              } else if (categorySnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Container();
                              }
                            },
                          ),
                          const SizedBox(height: 8),

                          // Brand
                          if (snapshot.data!.brand != null) ...{
                            StreamBuilder(
                              stream: singleBrand(snapshot.data!.brand),
                              builder: (context, brandSnapshot) {
                                if (brandSnapshot.hasData) {
                                  return RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Brand: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: brandSnapshot.data!.name,
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (brandSnapshot.hasError) {
                                  return Center(
                                      child:
                                          Text(brandSnapshot.error.toString()));
                                } else if (brandSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return Container();
                                }
                              },
                            )
                          },
                        ],
                      ),
                    ),

                    // Related Products
                    FB5Col(
                      classNames: 'col-12',
                      child: relatedProductsWidget(snapshot.data!),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Container();
              }
            },
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

            return FB5Row(
              classNames: 'pt-3',
              children: List.generate(
                categoryProducts.length,
                (index) => FB5Col(
                  classNames: 'col-lg-4 col-md-6 col-12 p-3',
                  child: ClientProductWidget(product: categoryProducts[index]),
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
