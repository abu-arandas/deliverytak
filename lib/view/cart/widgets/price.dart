import '/exports.dart';

class CartPrice extends StatefulWidget {
  const CartPrice({super.key});

  @override
  State<CartPrice> createState() => _CartPriceState();
}

class _CartPriceState extends State<CartPrice> {
  double total = 0;

  @override
  void initState() {
    super.initState();

    products().listen((event) {
      for (var product in event) {
        for (var element in CartController.instance.cartProducts) {
          if (product.id == element.id) {
            setState(() {
              total += (product.price * element.stock);
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          price(title: 'Products', data: total),
          price(title: 'Deliver', data: 1),
          price(title: 'Total', data: total + 1),
        ],
      );

  Widget price({
    required String title,
    required double data,
  }) =>
      Row(
        children: [
          Text(
            '$title :',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(data.toStringAsFixed(2)),
          const Text(
            ' JD',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      );
}
