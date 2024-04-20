import '/exports.dart';

class CartProduct extends StatefulWidget {
  final ProductModel cartProduct;
  const CartProduct({super.key, required this.cartProduct});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  String? size;
  ColorModel? color;

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.cartProduct.sizes.isNotEmpty) {
        size = widget.cartProduct.sizes.first;
      }

      if (widget.cartProduct.colors.isNotEmpty) {
        color = widget.cartProduct.colors.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) => GetBuilder<CartController>(
        builder: (controller) => StreamBuilder(
          stream: singleProduct(widget.cartProduct.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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
                      // Color
                      if (snapshot.data!.colors.isNotEmpty) ...{
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text('Color'),
                            Flexible(
                              child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    List.generate(
                                  snapshot.data!.colors.length,
                                  (index) => PopupMenuItem(
                                    value: snapshot.data!.colors[index],
                                    onTap: () {
                                      controller.cartProducts
                                          .singleWhere((element) =>
                                              element.id ==
                                              widget.cartProduct.id)
                                          .colors = [
                                        snapshot.data!.colors[index]
                                      ];

                                      controller.update();
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.circle,
                                        color:
                                            snapshot.data!.colors[index].color,
                                      ),
                                      title: Text(
                                        snapshot.data!.colors[index].name,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.circle,
                                    color: color?.color,
                                  ),
                                  title: Text(
                                    color != null
                                        ? color!.name
                                        : 'Select s color',
                                  ),
                                  trailing:
                                      const Icon(Icons.keyboard_arrow_down),
                                ),
                              ),
                            ),
                          ],
                        ),
                      },

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
                              '${(snapshot.data!.price * widget.cartProduct.stock).toStringAsFixed(2)} JD'),
                          const SizedBox(width: 16),
                          controller.cartButton(
                            color: color,
                            size: size,
                            id: snapshot.data!.id,
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
