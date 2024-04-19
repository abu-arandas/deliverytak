import '/exports.dart';

class AdminOrdersSection extends StatelessWidget {
  final List<OrderModel> ordersData;
  const AdminOrdersSection({super.key, required this.ordersData});

  @override
  Widget build(BuildContext context) {
    List<OrderModel> orders = ordersData
        .where((element) =>
            element.progress == OrderProgress.binding ||
            element.progress == OrderProgress.inProgress)
        .toList();

    orders.sort((a, b) => -(a.startTime.compareTo(b.startTime)));

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Orders',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (orders.isNotEmpty) ...{
            FB5Row(
              children: List.generate(
                orders.length,
                (index) => order(context: context, order: orders[index]),
              ),
            ),
          } else ...{
            Center(
              child: CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/empty%2Forders.png?alt=media&token=66cf5364-2066-4bb2-88e9-f21cebf34da9',
                fit: BoxFit.fill,
              ),
            )
          },
        ],
      ),
    );
  }

  FB5Col order({
    required BuildContext context,
    required OrderModel order,
  }) {
    double total = 0;

    for (var product in order.products) {
      total += (product.price * product.stock);
    }

    return FB5Col(
      classNames: 'col-lg-4 col-md-6 col-sm-12 p-3',
      child: ListTile(
        onTap: () => showDialog(
          context: context,
          builder: (context) => OrderDetails(order: order),
        ),
        leading: Icon(
          Icons.circle,
          color: progressColor(order.progress),
        ),
        title: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            progressDescription(order.progress),
          ),
        ),
        subtitle: Text(
          DateFormat.yMEd().format(order.startTime),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: Text(
          '${total.toStringAsFixed(2)} JD',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
