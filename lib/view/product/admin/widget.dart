import '/exports.dart';

class AdminProducts extends StatelessWidget {
  const AdminProducts({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => page(
                    context: context,
                    page: const AddProduct(),
                  ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: products(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return FB5Row(
                    children: List.generate(
                      snapshot.data!.length,
                      (index) => FB5Col(
                        classNames: 'col-lg-4 col-md-6 col-sm-12 p-1',
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),

                          // Image
                          leading: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data![index].image,
                              fit: BoxFit.fill,
                            ),
                          ),

                          // Name
                          title: Text(snapshot.data![index].name),

                          // Edit
                          trailing: IconButton(
                            onPressed: () => page(
                              context: context,
                              page: EditProduct(id: snapshot.data![index].id),
                            ),
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      maxHeight: 500,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/empty%2Fproducts.png?alt=media&token=83477763-0d9c-43c1-97ab-5d70b48fde68'),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          child: Text(
                            'There is no Products',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  snapshot.error.toString(),
                ));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      );
}
