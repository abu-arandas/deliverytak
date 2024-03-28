import '/exports.dart';

class ClientProductPage extends GetView<ProductController> {
  final String code;
  const ClientProductPage({super.key, required this.code});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: ProductController.instance.singleProduct(code),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FB5Container(
              child: FB5Row(
                children: [
                  // Image
                  FB5Col(
                    classNames: 'col-lg-6 col-md-6 col-sm-12',
                    child: Container(
                      width: double.maxFinite,
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data!.imageUrl),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                    ),
                  ),

                  // Informations
                  FB5Col(
                    classNames: 'col-lg-6 col-md-6 col-sm-12',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Padding(
                          padding: const EdgeInsets.all(16).copyWith(bottom: 0),
                          child: Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Category & Brand
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            toTitleCase(snapshot.data!.brandName),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                        // Images
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Row(
                              children: List.generate(
                                snapshot.data!.additionalImageUrls.length,
                                (index) => InkWell(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      contentPadding: EdgeInsets.zero,
                                      content: Image.network(
                                          snapshot
                                              .data!.additionalImageUrls[index],
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(12.5),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.5),
                                      image: DecorationImage(
                                        image: NetworkImage(snapshot
                                            .data!.additionalImageUrls[index]),
                                        fit: BoxFit.fill,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 5,
                                          blurStyle: BlurStyle.outer,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Price & Favorite & Cart
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${snapshot.data!.price} JD',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                              const Spacer(),
                              controller.favoriteButton(
                                id: snapshot.data!.id,
                                color: Colors.white,
                              ),
                              ProductController.instance.cartButton(
                                id: snapshot.data!.id,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  FB5Col(
                    classNames: 'col-12',
                    child: Container(
                      width: double.maxFinite,
                      height: 0.5,
                      margin: const EdgeInsets.all(16),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  // Related Products
                  FB5Col(
                    classNames: 'col-12',
                    child: Align(
                      alignment: Alignment.center,
                      child: title(context, 'Related Products'),
                    ),
                  ),
                  FB5Col(
                    classNames: 'col-12',
                    child: StreamBuilder(
                      stream: controller.categoryProducts(snapshot.data!),
                      builder: (context, categoryProductsSnapshot) {
                        if (categoryProductsSnapshot.hasData) {
                          List<ProductModel> categoryProducts =
                              categoryProductsSnapshot.data!.length >= 4
                                  ? List.generate(
                                      4,
                                      (index) =>
                                          categoryProductsSnapshot.data![index])
                                  : categoryProductsSnapshot.data!;

                          return FB5Container(
                            child: FB5Row(
                              children: List.generate(
                                categoryProducts.length,
                                (index) => FB5Col(
                                  classNames: 'col-lg-4 col-md-6 col-12 p-3',
                                  child: ClientProductWidget(
                                      id: categoryProducts[index].id),
                                ),
                              ),
                            ),
                          );
                        } else if (categoryProductsSnapshot.hasError) {
                          return Center(
                              child: Text(
                                  categoryProductsSnapshot.error.toString()));
                        } else if (categoryProductsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      );
}
