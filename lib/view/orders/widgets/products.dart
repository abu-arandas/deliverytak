import '/exports.dart';

class SingleOrderProducts extends StatelessWidget {
  final OrderModel order;
  const SingleOrderProducts({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Container(
        width: 500,
        margin: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: products(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductModel> products = snapshot.data!
                  .where((product) =>
                      order.products.any((element) => element.id == product.id))
                  .toList();

              return Column(
                children: List.generate(
                  order.products.length,
                  (index) => Card(
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(12.5),
                            bottomStart: Radius.circular(12.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: CachedNetworkImage(
                              imageUrl: products[index].images.first,
                              width: 50,
                              height: 75,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Informations
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              products[index].name,
                              maxLines: 2,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),

                            // Price
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                '${products[index].price.toStringAsFixed(2)} JD *${order.products[index].stock}',
                              ),
                            ),

                            // Size
                            if (products[index].sizes.isNotEmpty) ...{
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(products[index].sizes.first),
                              ),
                            },
                          ],
                        ),
                      ],
                    ),
                  ),
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
        ),
      );
}
