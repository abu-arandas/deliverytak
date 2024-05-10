import '/exports.dart';

class ClientShopData extends StatelessWidget {
  const ClientShopData({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<SortController>(
        builder: (controller) => StreamBuilder(
          stream: controller.limitProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductModel> products = snapshot.data!;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Showing ${products.length}'),
                      if (MediaQuery.sizeOf(context).width < 767) ...{
                        TextButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          child: const Text('sort'),
                        ),
                      }
                    ],
                  ),
                  if (products.isEmpty) ...{
                    Container(
                      width: 400,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
                      ),
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                                imageUrl:
                                    'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/empty%2Fproducts.png?alt=media&token=83477763-0d9c-43c1-97ab-5d70b48fde68'),
                          ),
                          Text(
                            'There are no products right now.\nWe will add them soon',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  } else ...{
                    FB5Row(
                      children: List.generate(
                        products.length,
                        (index) => FB5Col(
                          classNames: 'col-lg-4 col-md-6 col-sm-12 p-3',
                          child: ClientProductWidget(product: products[index]),
                        ),
                      ),
                    )
                  }
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
      );
}
