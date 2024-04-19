import '/exports.dart';

class ClientShopSort extends StatelessWidget {
  const ClientShopSort({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<SortController>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            ...{
              TextField(
                controller: controller.title,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  labelText: 'search product...',
                  border:
                      const OutlineInputBorder(borderRadius: BorderRadius.zero),
                  focusedBorder:
                      const OutlineInputBorder(borderRadius: BorderRadius.zero),
                  enabledBorder:
                      const OutlineInputBorder(borderRadius: BorderRadius.zero),
                  errorBorder:
                      const OutlineInputBorder(borderRadius: BorderRadius.zero),
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
            },

            // Categories
            ...{
              Text(
                'Categories',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              StreamBuilder(
                stream: categories(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FB5Row(
                      classNames: 'justify-content-center',
                      children: List.generate(
                        snapshot.data!.length,
                        (index) => FB5Col(
                          classNames: 'col-6',
                          child: ListTile(
                            onTap: () {
                              controller.categoryModel = snapshot.data![index];
                              controller.update();
                            },
                            title: Text(
                              toTitleCase(snapshot.data![index].name),
                              style: TextStyle(
                                color: controller.categoryModel ==
                                        snapshot.data![index]
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            trailing: controller.categoryModel ==
                                    snapshot.data![index]
                                ? IconButton(
                                    onPressed: () {
                                      controller.categoryModel = null;
                                      controller.update();
                                    },
                                    icon: const Icon(Icons.close),
                                  )
                                : null,
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
              const SizedBox(height: 32),
            },

            // Brands
            ...{
              Text(
                'Brands',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              StreamBuilder(
                stream: brands(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FB5Row(
                      classNames: 'justify-content-center',
                      children: List.generate(
                        snapshot.data!.length,
                        (index) => FB5Col(
                          classNames: 'col-6',
                          child: ListTile(
                            onTap: () {
                              controller.brandModel = snapshot.data![index];
                              controller.update();
                            },
                            title: Text(
                              toTitleCase(snapshot.data![index].name),
                              style: TextStyle(
                                color: controller.brandModel ==
                                        snapshot.data![index]
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            trailing:
                                controller.brandModel == snapshot.data![index]
                                    ? IconButton(
                                        onPressed: () {
                                          controller.brandModel = null;
                                          controller.update();
                                        },
                                        icon: const Icon(Icons.close),
                                      )
                                    : null,
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
              const SizedBox(height: 32),
            },
          ],
        ),
      );
}
