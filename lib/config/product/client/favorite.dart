import '/exports.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        init: ProductController(),
        builder: (controller) {
          if (controller.favoriteProducts.isEmpty) {
            return Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty/favorite.png',
                    fit: BoxFit.fill,
                  ),
                  const Text(
                    'Wish List is Empty\nDiscover our Products.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldController.instance
                          .setPage(name: 'shop', widget: const Shop());
                      ScaffoldController.instance.update();
                    },
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height * 0.75),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  pageTtitle(
                    context: context,
                    text: 'Favorite Products',
                    bg: 'assets/images/title/favorite.jpg',
                  ),
                  FB5Row(
                    children: List.generate(
                      controller.favoriteProducts.length,
                      (index) => FB5Col(
                        classNames: 'col-lg-4 col-md-6 col-sm-12 p-3',
                        child: StreamBuilder(
                          stream: controller.singleProduct(
                              controller.favoriteProducts[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ClientProductWidget(id: snapshot.data!.id);
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(snapshot.error.toString()));
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      );
}
