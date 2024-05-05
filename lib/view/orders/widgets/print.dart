import '/exports.dart';

class SingleOrderPrintButton extends StatelessWidget {
  final OrderModel order;
  const SingleOrderPrintButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: singleUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.role == UserRole.admin) {
              return ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: printerLabel(order),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff198754),
                ),
                child: const Text('Print'),
              );
            } else {
              return Container();
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      );

  Widget printerLabel(OrderModel order) {
    Widget divider() => Container(
          height: 10,
          width: double.maxFinite,
          margin: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: 100,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Container(
              height: 1,
              width: 5,
              color: Colors.black,
              margin: const EdgeInsets.all(4),
            ),
          ),
        );

    Widget data(String title, String info) => Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(
                '${title.tr} : ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                info,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );

    double total = 0;

    return StreamBuilder(
      stream: singleUser(order.clientId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),

                // Logo
                App.logo(color: Colors.black),
                divider(),

                // Informations
                const SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    'Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                data('Name', snapshot.data!.name['first']),
                data('Phone Number', snapshot.data!.phone.international),
                data('Time', DateFormat.yMMMMEEEEd().format(order.startTime)),
                divider(),

                // Products
                const SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    'Products',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                StreamBuilder(
                  stream: products(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: List.generate(
                          order.products.length,
                          (index) {
                            double price = 0;

                            price = snapshot.data![index].price;

                            total += (price * order.products[index].stock);

                            return Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(snapshot.data![index].name),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    price.toStringAsFixed(2),
                                  ),
                                  Text(' * ${order.products[index].stock}'),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Container();
                    }
                  },
                ),

                const Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total : ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      total.toStringAsFixed(2),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container();
        }
      },
    );
  }
}
