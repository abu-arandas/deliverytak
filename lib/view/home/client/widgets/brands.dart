import '/exports.dart';

class ClientBrands extends StatefulWidget {
  const ClientBrands({super.key});

  @override
  State<ClientBrands> createState() => _ClientBrandsState();
}

class _ClientBrandsState extends State<ClientBrands> {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      Timer.periodic(
        const Duration(seconds: 2),
        (timer) => scrollController.animateTo(
          scrollController.offset + 100,
          duration: const Duration(seconds: 2),
          curve: Curves.ease,
        ),
      );
    });
  }

  GlobalKey containerKey = GlobalKey();
  GlobalKey brandsKey = GlobalKey();

  @override
  Widget build(BuildContext context) => FB5Container(
        key: containerKey,
        child: StreamBuilder(
          stream: brands(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                children: [
                  if (containerKey.currentContext != null &&
                      brandsKey.currentContext != null) ...{
                    if (containerKey.currentContext!.width <=
                        brandsKey.currentContext!.width) ...{
                      IconButton(
                        onPressed: () => scrollController.animateTo(
                          scrollController.offset - 100,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease,
                        ),
                        icon: const Icon(Icons.keyboard_arrow_left),
                      )
                    }
                  },
                  Expanded(
                    key: brandsKey,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: scrollController,
                      child: Row(
                        children: List.generate(
                          snapshot.data!.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () {
                                SortController.instance.brand =
                                    snapshot.data![index].id;
                                SortController.instance.update();

                                page(
                                  context: context,
                                  page: const ClientShop(),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data![index].image,
                                width: 150,
                                height: 75,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (containerKey.currentContext != null &&
                      brandsKey.currentContext != null) ...{
                    if (containerKey.currentContext!.width <=
                        brandsKey.currentContext!.width) ...{
                      IconButton(
                        onPressed: () => scrollController.animateTo(
                          scrollController.offset + 100,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease,
                        ),
                        icon: const Icon(Icons.keyboard_arrow_right),
                      ),
                    }
                  },
                ],
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
      );
}
