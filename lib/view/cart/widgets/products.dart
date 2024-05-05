import '/exports.dart';

class CartProducts extends StatelessWidget {
  const CartProducts({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<CartController>(
        builder: (controller) => StreamBuilder(
          stream: products(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(4),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                },
                children: [
                  // Title
                  const TableRow(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide()),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('image'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('title'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('price'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('size'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('color'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('count'),
                      ),
                    ],
                  ),

                  // Products
                  for (CartModel product in controller.cartProducts) ...{
                    productRow(
                      controller,
                      snapshot.data!
                          .singleWhere((element) => element.id == product.id),
                    ),
                  }
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
        ),
      );

  TableRow productRow(
    CartController productController,
    ProductModel product,
  ) {
    int size = productController.cartProducts
        .singleWhere((element) => element.id == product.id)
        .size;
    int color = productController.cartProducts
        .singleWhere((element) => element.id == product.id)
        .color;
    int stock = productController.cartProducts
        .singleWhere((element) => element.id == product.id)
        .stock;

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: CachedNetworkImage(
            imageUrl: product.images.first,
            width: 50,
            height: 75,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(product.name),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(product.price.toStringAsFixed(2)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: PopupMenuButton(
            itemBuilder: (BuildContext context) => List.generate(
              product.sizes.length,
              (index) => PopupMenuItem(
                onTap: () {
                  productController.cartProducts
                      .singleWhere((element) => element.id == product.id)
                      .size = index;

                  productController.update();
                },
                child: Text(product.sizes[index]),
              ),
            ),
            child: ListTile(
              title: Text(
                product.sizes.length == 1
                    ? 'Product have a single size'
                    : 'Size is : ${product.sizes[size]}',
                style: const TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: PopupMenuButton(
            itemBuilder: (BuildContext context) => List.generate(
              product.colors.length,
              (index) => PopupMenuItem(
                onTap: () {
                  productController.cartProducts
                      .singleWhere((element) => element.id == product.id)
                      .color = index;

                  productController.update();
                },
                child: Row(
                  children: [
                    Icon(Icons.circle, color: product.colors[index]),
                    const SizedBox(width: 4),
                    Text(ColorTools.nameThatColor(product.colors[index])),
                  ],
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.circle,
                color: product.colors[color],
              ),
              title: Text(
                product.colors.length == 1
                    ? 'Product have a single color'
                    : 'Color is : ${ColorTools.nameThatColor(product.colors[color])}',
                style: const TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(stock.toString()),
              Column(
                children: [
                  if (stock <= product.stock) ...{
                    InkWell(
                      onTap: () {
                        productController.cartProducts
                            .singleWhere((element) => element.id == product.id)
                            .stock++;
                        productController.update();
                      },
                      child: const Icon(Icons.keyboard_arrow_up),
                    )
                  },
                  if (stock >= 1) ...{
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        if (stock == 1) {
                          productController.cartProducts.removeWhere(
                              (element) => element.id == product.id);
                        } else {
                          productController.cartProducts
                              .singleWhere(
                                  (element) => element.id == product.id)
                              .stock--;
                        }

                        productController.update();
                      },
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  }
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
