import '/exports.dart';

class CartProduct extends StatefulWidget {
  final ProductModel cartProduct;
  const CartProduct({super.key, required this.cartProduct});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  String? size;

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.cartProduct.sizes.isNotEmpty) {
        size = widget.cartProduct.sizes.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) => GetBuilder<CartController>(
        builder: (controller) => StreamBuilder(
          stream: singleProduct(widget.cartProduct.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ProductModel productModel = widget.cartProduct;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  // -- Image
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12.5),
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data!.image,
                      fit: BoxFit.fill,
                    ),
                  ),

                  // Title
                  title: Text(
                    snapshot.data!.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                  ),

                  subtitle: Column(
                    children: [
                      // Size
                      if (snapshot.data!.sizes.isNotEmpty) ...{
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text('Size'),
                            Flexible(
                              child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    List.generate(
                                  snapshot.data!.sizes.length,
                                  (index) => PopupMenuItem(
                                    onTap: () {
                                      controller.cartProducts
                                          .singleWhere((element) =>
                                              element.id ==
                                              widget.cartProduct.id)
                                          .sizes = [
                                        snapshot.data!.sizes[index]
                                      ];

                                      controller.update();

                                      setState(() =>
                                          size = snapshot.data!.sizes[index]);
                                    },
                                    child: Text(snapshot.data!.sizes[index]),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    size ?? 'Selecet a Size',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  trailing:
                                      const Icon(Icons.keyboard_arrow_down),
                                ),
                              ),
                            ),
                          ],
                        ),
                      },

                      // Price & Quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(snapshot.data!.price * widget.cartProduct.stock).toStringAsFixed(2)} JD',
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              // Remove
                              IconButton(
                                onPressed: () {
                                  if (productModel.stock > 1) {
                                    productModel.stock--;
                                    controller.update();
                                  } else {
                                    controller.cartProducts.removeWhere(
                                        (element) =>
                                            element.id ==
                                            widget.cartProduct.id);
                                    controller.update();
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),

                              // Count
                              Text(productModel.stock.toString()),

                              // Add
                              if (snapshot.data!.stock >=
                                  productModel.stock) ...{
                                IconButton(
                                  onPressed: () {
                                    controller.cartProducts
                                        .singleWhere((element) =>
                                            element.id == widget.cartProduct.id)
                                        .copyWith(
                                          sizes: size != null ? [size!] : null,
                                          stock: productModel.stock++,
                                        );

                                    controller.update();
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              },
                            ],
                          )
                        ],
                      ),
                    ],
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
      );
}
