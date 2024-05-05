import '/exports.dart';

class SingleOrderPayment extends StatelessWidget {
  final OrderModel order;
  const SingleOrderPayment({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Container(
        width: 500,
        margin: const EdgeInsets.all(16).copyWith(bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.5),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesomeIcons.dollarSign,
              color: Colors.white,
            ),
          ),
          title: Text(
            paymentDetails(order.payment),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
}
