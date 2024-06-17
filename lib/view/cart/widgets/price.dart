import '/exports.dart';

class CartPrice extends StatelessWidget {
  const CartPrice({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: products(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GetBuilder<CartController>(
              builder: (controller) {
                double total = 0;

                for (var product in snapshot.data!) {
                  for (var element in controller.cartProducts) {
                    if (product.id == element.id) {
                      total += (product.price * element.stock);
                    }
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    price(title: 'Products', data: total),
                    price(title: 'Deliver', data: 1),
                    price(title: 'Total', data: total + 1),
                  ],
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
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
