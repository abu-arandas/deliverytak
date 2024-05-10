import '/exports.dart';

class AdminCategories extends StatelessWidget {
  const AdminCategories({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const AddCategory(),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: categories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FB5Row(
                    classNames: 'p-3',
                    children: List.generate(
                      snapshot.data!.length,
                      (index) => FB5Col(
                        classNames: 'col-lg-6 col-md-6 col-sm-12 col-xs-12 p-1',
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => CategoryDetails(
                              category: snapshot.data![index],
                            ),
                          ),

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
                              builder: (context) => EditCategory(
                                categoryModel: snapshot.data![index],
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
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      );
}
