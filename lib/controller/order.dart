import '/exports.dart';

class OrderController extends GetxController {
  static OrderController instance = Get.find();

  CollectionReference<Map<String, dynamic>> ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  /* ====== Progress ======*/
  Color progressColor(OrderProgress progress) {
    Color color;

    switch (progress) {
      case OrderProgress.binding:
        color = Colors.blue;
        break;
      case OrderProgress.inProgress:
        color = const Color(0xFF01b075);
        break;
      case OrderProgress.done:
        color = Colors.grey;
        break;

      default:
        color = Colors.blueGrey;
    }

    return color;
  }

  String progressDescription(OrderProgress progress) {
    String text;

    switch (progress) {
      case OrderProgress.binding:
        text = 'Waiting the shop to prepare it.';
        break;
      case OrderProgress.inProgress:
        text = 'Waiting the delivey company';
        break;
      case OrderProgress.done:
        text = 'Delivered';
        break;

      default:
        text = '';
    }

    return text;
  }

  /* ====== Read ====== */
  Stream<List<OrderModel>> orders() => ordersCollection.snapshots().map(
      (query) => query.docs.map((item) => OrderModel.fromJson(item)).toList());

  Stream<OrderModel> singleOrder(id) => ordersCollection
      .doc(id)
      .snapshots()
      .map((query) => OrderModel.fromJson(query));

  Stream<List<OrderModel>> clientOrders(String id) =>
      ordersCollection.snapshots().map((query) => query.docs
          .map((item) => OrderModel.fromJson(item))
          .where((element) => element.clientId == id)
          .toList());

  Stream<List<OrderModel>> clientOrdersByDay(String id, DateTime day) =>
      ordersCollection.snapshots().map((query) => query.docs
          .map((item) => OrderModel.fromJson(item))
          .where((element) =>
              element.clientId == id &&
              (DateTime(element.startTime.year, element.startTime.month,
                      element.startTime.day) ==
                  DateTime(day.year, day.month, day.day)))
          .toList());

  /* ====== Update ======*/
  updateOrder(context, OrderModel order) {
    try {
      succesSnackBar('Updated');
      ScaffoldController.instance
          .setPage(name: 'home', widget: const ClientHome());
      ScaffoldController.instance.update();
    } catch (error) {
      errorSnackBar(error.toString());
    }
  }

  /* ====== Delete ======*/
  Widget deleteOrder(BuildContext context, String id) => IconButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  try {
                    ordersCollection.doc(id).delete();

                    succesSnackBar('Deleted');
                    ScaffoldController.instance
                        .setPage(name: 'home', widget: const ClientHome());
                    ScaffoldController.instance.update();
                  } catch (error) {
                    errorSnackBar(error.toString());
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
        style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
      );
}
