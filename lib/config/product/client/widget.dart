import '/exports.dart';

class ClientProductWidget extends StatelessWidget {
  final String id;
  const ClientProductWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: ProductController.instance.singleProduct(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              onTap: () {
                ScaffoldController.instance.setPage(
                    name: 'shop',
                    widget: ClientProductPage(code: snapshot.data!.id));
                ScaffoldController.instance.update();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data!.imageUrl),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),

                    //  Brand
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        snapshot.data!.brandName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9c9c9c),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    // Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        snapshot.data!.name,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Price
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${snapshot.data!.price} JD',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ProductController.instance
                              .favoriteButton(id: snapshot.data!.id),
                          ProductController.instance
                              .cartButton(id: snapshot.data!.id),
                        ],
                      ),
                    ),
                  ],
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
      );
}
