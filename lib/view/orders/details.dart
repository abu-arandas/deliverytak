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
          SingleOrderPrintButton(order: widget.order),
          SingleOrderStartButton(order: widget.order),
          SingleOrderDeleteButton(order: widget.order),
          SingleOrderDeliverButton(order: widget.order),
        ],
      );
}
