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

              return FB5Row(
                children: List.generate(
                  products.length,
                  (index) => FB5Col(
                    classNames: 'col-6 p-3',
                    child: ListTile(
                      isThreeLine: true,
                      leading: CachedNetworkImage(
                        imageUrl: products[index].images.first,
                      ),
                      title: Text(products[index].name),
                      subtitle: Text(products[index].description),
                      trailing: Text(
                        products[index].price.toStringAsFixed(2),
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
