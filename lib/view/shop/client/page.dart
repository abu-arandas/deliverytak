import '/exports.dart';

// TODO Sort

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<ProductModel> products = [];
  TextEditingController title = TextEditingController();

  List<String> brands = [];

  @override
  void initState() {
    super.initState();

    ProductController.instance.products().listen((event) => setState(() {
          products = event;

          for (var element in event.map((e) => e.brandName).toList()) {
            if (!brands.contains(element)) {
              brands.add(element);
            }
          }

          setDrawer(
            brands: brands,
            productsData: event,
          );
        }));
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          pageTtitle(
            context: context,
            text: 'Our Products',
            bg: 'assets/images/title/products.jpeg',
            addition: TextButton(
              onPressed: () => ScaffoldController
                  .instance.scaffoldKey.currentState!
                  .openDrawer(),
              child: const Text(
                'sort',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // Products
          if (products.isEmpty) ...{
            Container(
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
                    'assets/images/empty/products.png',
                    fit: BoxFit.fill,
                  ),
                  const Text(
                    'There are no products right now.\nWe will add them soon',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          } else ...{
            FB5Row(
              classNames: 'p-3',
              children: List.generate(
                products.length,
                (index) => FB5Col(
                  classNames: 'col-lg-3 col-md-6 col-sm-12 p-3',
                  child: ClientProductWidget(id: products[index].id),
                ),
              ),
            ),
          }
        ],
      );

  void setDrawer({
    required List<String> brands,
    required List<ProductModel> productsData,
  }) {
    ScaffoldController.instance.drawer = Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Sort the Products',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: title,
                decoration: InputDecoration(
                  labelText: 'product name',
                  suffixIcon: title.text.isNotEmpty
                      ? IconButton(
                          onPressed: () => setState(() {
                            title = TextEditingController();
                            products = productsData;
                          }),
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      products = productsData
                          .where((element) => element.name.contains(value))
                          .toList();
                    } else {
                      products = productsData;
                    }
                  });
                },
              ),
            ),

            // Price
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Text('Price: '),
                  const Spacer(),
                  IconButton(
                    onPressed: () => setState(() {
                      products.sort((a, b) => -(a.price.compareTo(b.price)));
                    }),
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      products.sort((a, b) => a.price.compareTo(b.price));
                    }),
                    icon: const Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),

            // Brands
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Brands: '),
                  Expanded(
                    child: Wrap(
                      children: List.generate(
                        brands.length,
                        (index) => TextButton(
                          onPressed: () => setState(() {
                            products = products
                                .where(
                                    (e) => e.brandName.contains(brands[index]))
                                .toList();
                          }),
                          child: Text(brands[index]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ScaffoldController.instance.update();
  }
}
