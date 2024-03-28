import '/exports.dart';

class ClientCartProduct extends StatelessWidget {
  final String id;
  const ClientCartProduct({super.key, required this.id});

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        builder: (controller) {
          ProductModel product = controller.cartProducts
              .singleWhere((element) => element.id == id);

          return Card(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                // -- Image
                Container(
                  width: 150,
                  height: double.maxFinite,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.5),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                // -- Informations
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 0.9,
                          ),
                          maxLines: 2,
                        ),
                      ),

                      // Price & Quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${(product.price * product.stock).toStringAsFixed(2)} JD',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const Spacer(),
                          controller.cartButton(id: id)
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
}
