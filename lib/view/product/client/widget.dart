import '/exports.dart';

class ClientProductWidget extends StatelessWidget {
  final ProductModel product;
  const ClientProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => page(
          context: context,
          page: ProductDetails(id: product.id),
        ),
        child: CachedNetworkImage(
          imageUrl: product.images.first,
          imageBuilder: (context, imageProvider) => AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.25),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Name
                  Padding(
                    padding: const EdgeInsets.all(8).copyWith(bottom: 16),
                    child: Text(
                      product.name,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  // Details
                  ElevatedButton(
                    onPressed: () => page(
                      context: context,
                      page: ProductDetails(id: product.id),
                    ),
                    style: ButtonStyle(
                      shape: const MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => states.contains(MaterialState.hovered) ||
                                states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed)
                            ? Colors.black
                            : Colors.white,
                      ),
                      foregroundColor: MaterialStateColor.resolveWith(
                        (states) => states.contains(MaterialState.hovered) ||
                                states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed)
                            ? Colors.white
                            : Colors.black,
                      ),
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                    ),
                    child: Text(
                        'Shop Now : ${product.price.toStringAsFixed(2)} JD'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
