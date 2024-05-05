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

            // Gender
            ...{
              Text(
                'Genders',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GetBuilder<SortController>(
                builder: (controller) {
                  return FB5Row(
                    children: List.generate(
                      Genders.values.length,
                      (index) => FB5Col(
                        classNames: 'col-6',
                        child: ListTile(
                          onTap: () {
                            controller.gender = Genders.values[index];
                            controller.update();
                          },
                          title: Text(
                            toTitleCase(
                              genders.reverse[Genders.values[index]]!
                                  .toUpperCase(),
                            ),
                            style: TextStyle(
                              color: controller.gender == Genders.values[index]
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          trailing: controller.gender == Genders.values[index]
                              ? IconButton(
                                  onPressed: () {
                                    controller.gender = null;
                                    controller.update();
                                  },
                                  icon: const Icon(Icons.close),
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              )
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
                      children: List.generate(
                        snapshot.data!.length,
                        (index) => FB5Col(
                          classNames: 'col-6',
                          child: ListTile(
                            onTap: () {
                              controller.category = snapshot.data![index].id;
                              controller.update();
                            },
                            title: Text(
                              toTitleCase(snapshot.data![index].name),
                              style: TextStyle(
                                color: controller.category ==
                                        snapshot.data![index].id
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            trailing:
                                controller.category == snapshot.data![index].id
                                    ? IconButton(
                                        onPressed: () {
                                          controller.category = null;
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
                      children: List.generate(
                        snapshot.data!.length,
                        (index) => FB5Col(
                          classNames: 'col-6',
                          child: ListTile(
                            onTap: () {
                              controller.brand = snapshot.data![index].id;
                              controller.update();
                            },
                            title: Text(
                              toTitleCase(snapshot.data![index].name),
                              style: TextStyle(
                                color:
                                    controller.brand == snapshot.data![index].id
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            trailing:
                                controller.brand == snapshot.data![index].id
                                    ? IconButton(
                                        onPressed: () {
                                          controller.brand = null;
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
