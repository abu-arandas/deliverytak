import '/exports.dart';

class SingleOrderQR extends StatelessWidget {
  final OrderModel order;
  const SingleOrderQR({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Container(
        width: 500,
        height: 75,
        margin: const EdgeInsets.all(16).copyWith(bottom: 0),
        child: BarcodeWidget(
          barcode: Barcode.code93(),
          data: order.id,
          height: 75,
        ),
      );
}
