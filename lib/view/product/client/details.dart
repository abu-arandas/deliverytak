import '/exports.dart';

class ProductDetails extends StatefulWidget {
  final String id;
  const ProductDetails({super.key, required this.id});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) => ClientScaffold(
        pageName: 'product',
        pageImage: '',
        body: FB5Container(
          child: StreamBuilder(
            stream: singleProduct(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    FB5Row(
                      classNames: 'align-items-start',
                      children: [
                        FB5Col(
                          classNames: 'col-lg-6 col-md-6 col-sm-12',
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                        FB5Col(
                          classNames: 'col-lg-6 col-md-6 col-sm-12 p-3',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                snapshot.data!.name.toUpperCase(),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 16),

                              // Description
                              Text(snapshot.data!.description),
                              const SizedBox(height: 16),

                              // Price
                              Text(
                                '${snapshot.data!.price.toStringAsFixed(2)} JD',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              const SizedBox(height: 20),

                              // Sizes
                              if (snapshot.data!.sizes.isNotEmpty) ...{
                                Row(
                                  children: [
                                    const Text(
                                      'Sizes: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    for (var element
                                        in snapshot.data!.sizes) ...{
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(element),
                                      )
                                    }
                                  ],
                                ),
                              },

                              const SizedBox(height: 16),

                              // Cart
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: GetBuilder<CartController>(
                                  builder: (controller) => ElevatedButton(
                                    onPressed: () {
                                      ProductModel product = snapshot.data!;

                                      controller.cartProducts.add(
                                        product.copyWith(stock: 1),
                                      );

                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Added to cart'),
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                  'Continue Shopping'),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () => page(
                                                context: context,
                                                page: const Cart(),
                                              ),
                                              child: const Text('View Cart'),
                                            ),
                                          ],
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
                              ),
                              const SizedBox(height: 16),

                              // Category
                              StreamBuilder(
                                stream: category(snapshot.data!.category),
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
                                  stream: brand(snapshot.data!.brand),
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
                                          child: Text(
                                              brandSnapshot.error.toString()));
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
                      ],
                    ),
                    relatedProductsWidget(snapshot.data!),
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

  Widget images(ProductModel product) => Row(
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
