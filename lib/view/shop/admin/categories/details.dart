import '/exports.dart';

class CategoryDetails extends StatelessWidget {
  final CategoryModel category;
  const CategoryDetails({super.key, required this.category});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(imageUrl: category.image),
          title: Text(category.name),
        ),
        content: StreamBuilder(
          stream: products(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductModel> products = snapshot.data!
                  .where((element) => element.category == category.id)
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
