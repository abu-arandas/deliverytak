import '/exports.dart';

class AdminSearch extends StatelessWidget {
  const AdminSearch({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<SortController>(
        builder: (controller) => Container(
          height: MediaQuery.sizeOf(context).height,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search Products',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  labelText: 'search product...',
                  prefixIcon: const Icon(Icons.search),
                  suffix: IconButton.filled(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      shape: const BeveledRectangleBorder(),
                    ),
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: StreamBuilder(
                  stream: controller.limitProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) => ListTile(
                          // Image
                          leading: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data![index].images.first,
                              fit: BoxFit.fill,
                            ),
                          ),

                          // Name
                          title: Text(
                            snapshot.data![index].name,
                            maxLines: 2,
                          ),

                          // Edit
                          trailing: IconButton(
                            onPressed: () => page(
                              context: context,
                              page: EditProduct(id: snapshot.data![index].id),
                            ),
                            icon: const Icon(Icons.edit),
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
              )
            ],
          ),
        ),
      );
}
