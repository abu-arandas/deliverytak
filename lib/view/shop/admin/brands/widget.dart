import '/exports.dart';

class AdminBrands extends StatelessWidget {
  const AdminBrands({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Brands',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const AddBrand(),
                  ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: brands(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FB5Row(
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => FB5Col(
                      classNames: 'col-lg-6 col-md-6 col-sm-12 col-xs-12 p-1',
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
                        subtitle: TextButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => EditBrand(
                              brandModel: snapshot.data![index],
                            ),
                          ),
                          child: const Text('edit'),
                        ),
                      ),
                    ),
                  ),
                );
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
