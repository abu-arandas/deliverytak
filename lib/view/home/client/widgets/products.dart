import '/exports.dart';

class ClientProducts extends StatelessWidget {
  const ClientProducts({super.key});

  @override
  Widget build(BuildContext context) => FB5Container(
        child: StreamBuilder(
          stream: products(),
          builder: (context, productSnapshot) {
            if (productSnapshot.hasData) {
              List<ProductModel> products = productSnapshot.data!.length > 3
                  ? List.generate(3, (index) => productSnapshot.data![index])
                  : productSnapshot.data!;

              return FB5Row(
                classNames: 'px-3 py-5 justify-content-center',
                children: List.generate(
                  products.length,
                  (index) => FB5Col(
                    classNames: 'col-lg-4 col-md-6 col-sm-12 p-3',
                    child: ClientProductWidget(product: products[index]),
                  ),
                ),
              );
            } else if (productSnapshot.hasError) {
              return Center(
                  child: Text(
                productSnapshot.error.toString(),
              ));
            } else if (productSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          },
        ),
      );
}
