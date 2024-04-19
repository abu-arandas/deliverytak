import '/exports.dart';

class AdminPanelsSection extends StatelessWidget {
  final List<OrderModel> orders;
  final List<ProductModel> products;
  final List<UserModel> clients;

  const AdminPanelsSection({
    super.key,
    required this.orders,
    required this.products,
    required this.clients,
  });

  @override
  Widget build(BuildContext context) => FB5Row(
        children: [
          panel(
            context: context,
            icon: Icons.shopping_cart,
            title: 'Orders',
            data: orders.length.toString(),
          ),
          panel(
            context: context,
            icon: FontAwesomeIcons.dollarSign,
            title: 'Selling',
            data: total().toStringAsFixed(1),
          ),
          panel(
            context: context,
            icon: Icons.shop,
            title: 'Products',
            data: products.length.toString(),
          ),
          panel(
            context: context,
            icon: Icons.person,
            title: 'Users',
            data: clients.length.toString(),
          ),
        ],
      );

  FB5Col panel({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String data,
  }) =>
      FB5Col(
        classNames: 'col-lg-3 col-md-4 col-sm-6 col-xs-6',
        child: Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary),
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(data, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      );

  double total() {
    double total = 0;

    for (var order in orders) {
      for (var product in order.products) {
        total += (product.price * product.stock);
      }
    }

    return total;
  }
}
