import '/exports.dart';

class SingleOrderPrice extends StatefulWidget {
  final OrderModel order;
  const SingleOrderPrice({super.key, required this.order});

  @override
  State<SingleOrderPrice> createState() => _SingleOrderPriceState();
}

class _SingleOrderPriceState extends State<SingleOrderPrice> {
  double total = 0;

  @override
  void initState() {
    super.initState();

    products().listen((event) {
      setState(() {});
    });

    for (var product in widget.order.products) {
      singleProduct(product.id).listen((event) {
        total += (event.price * product.stock);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        width: 500,
        margin: const EdgeInsets.all(16).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            priceWidget(context: context, title: 'Products', date: total),
            priceWidget(context: context, title: 'Delivery', date: 1),
          ],
        ),
      );

  Widget priceWidget({
    required BuildContext context,
    required String title,
    required double date,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8).copyWith(bottom: 0),
        child: Row(
          children: [
            Text(
              '$title : ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              date.toStringAsFixed(2),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
}
