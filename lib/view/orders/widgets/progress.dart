import '/exports.dart';

class SingleOrderProgress extends StatelessWidget {
  final OrderModel order;
  const SingleOrderProgress({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Container(
        width: 500,
        margin: const EdgeInsets.all(16).copyWith(bottom: 0),
        child: Column(
          children: [
            Text(
              progressDescription(order.progress),
              style: TextStyle(
                color: progressColor(order.progress),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => progressWidget(
                  context: context,
                  progress: order.progress,
                  select: OrderProgress.values[index] == order.progress,
                ),
              ),
            )
          ],
        ),
      );

  Widget progressWidget({
    required BuildContext context,
    required OrderProgress progress,
    required bool select,
  }) =>
      Container(
        height: 2,
        constraints: const BoxConstraints(maxWidth: 100),
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.5),
          color: order.progress == OrderProgress.deleted
              ? const Color(0xffdc3545)
              : select
                  ? progressColor(order.progress)
                  : Colors.grey,
        ),
      );
}
