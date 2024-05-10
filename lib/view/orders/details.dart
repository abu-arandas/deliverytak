import '/exports.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel order;

  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleOrderMap(order: widget.order),
                SingleOrderQR(order: widget.order),
                SingleOrderProgress(order: widget.order),
                SingleOrderTime(order: widget.order),
                if (FirebaseAuth.instance.currentUser!.uid !=
                    widget.order.clientId) ...{
                  SingleOrderUser(userId: widget.order.clientId)
                },
                if (FirebaseAuth.instance.currentUser!.uid !=
                        widget.order.driverId &&
                    widget.order.driverId != null) ...{
                  SingleOrderUser(userId: widget.order.driverId!)
                },
                SingleOrderPrice(order: widget.order),
                SingleOrderPayment(order: widget.order),
                SingleOrderProducts(order: widget.order),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              SingleOrderPrintButton(order: widget.order),
              const SizedBox(width: 8),
              SingleOrderStartButton(order: widget.order),
              const SizedBox(width: 8),
              SingleOrderDeleteButton(order: widget.order),
              const SizedBox(width: 8),
              SingleOrderDeliverButton(order: widget.order),
            ],
          )
        ],
      );
}
