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

              return SingleChildScrollView(
                child: FB5Row(
                  children: List.generate(
                    products.length,
                    (index) => FB5Col(
                      classNames: 'col-12 p-1',
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
