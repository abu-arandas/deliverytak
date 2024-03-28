import '/exports.dart';

class MostSelling extends StatelessWidget {
  const MostSelling({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          title(context, 'Most Selling'),
          StreamBuilder(
            stream: OrderController.instance.orders(),
            builder: (context, ordersSnapshot) {
              if (ordersSnapshot.hasData) {
                return StreamBuilder(
                  stream: ProductController.instance.products(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.hasData) {
                      List<ProductModel> products =
                          ProductController.instance.bestSeller(
                        ordersSnapshot.data!,
                        productSnapshot.data!,
                      );

                      return FB5Container(
                        child: FB5Row(
                          classNames: 'p-3',
                          children: List.generate(
                            products.length,
                            (index) => FB5Col(
                              classNames: 'col-lg-3 col-md-6 col-sm-12 p-3',
                              child:
                                  ClientProductWidget(id: products[index].id),
                            ),
                          ),
                        ),
                      );
                    } else if (productSnapshot.hasError) {
                      return Center(
                          child: Text(productSnapshot.error.toString()));
                    } else if (productSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Container();
                    }
                  },
                );
              } else if (ordersSnapshot.hasError) {
                return Center(child: Text(ordersSnapshot.error.toString()));
              } else if (ordersSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Container();
              }
            },
          ),
        ],
      );
}
