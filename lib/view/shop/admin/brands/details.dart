import '/exports.dart';

class BrandDetails extends StatelessWidget {
  final BrandModel brand;
  const BrandDetails({super.key, required this.brand});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(imageUrl: brand.image),
          title: Text(brand.name),
        ),
        content: StreamBuilder(
          stream: products(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductModel> products = snapshot.data!
                  .where((element) => element.brand == brand.id)
                  .toList();

              return SingleChildScrollView(
                child: FB5Row(
                  children: List.generate(
                    products.length,
                    (index) => FB5Col(
                      classNames: 'col-lg-4 col-md-6 col-sm-12 col-xs-12 p-1',
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: products[index].images.first,
                              width: 50,
                              height: 50,
                            ),
                            Expanded(child: Text(products[index].name)),
                            Text(
                              '${products[index].price.toStringAsFixed(2)} JD',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
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
