import '/exports.dart';

class SingleOrderTime extends StatelessWidget {
  final OrderModel order;
  const SingleOrderTime({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Container(
        width: 500,
        margin: const EdgeInsets.all(16).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            timeWidget(
              context: context,
              title: 'Strated',
              date: order.startTime,
            ),
            if (order.acceptTime != null) ...{
              timeWidget(
                context: context,
                title: 'Accepted',
                date: order.acceptTime!,
              )
            },
            if (order.pickTime != null) ...{
              timeWidget(
                context: context,
                title: 'Picked',
                date: order.pickTime!,
              )
            },
          ],
        ),
      );
  Widget timeWidget({
    required BuildContext context,
    required String title,
    required DateTime date,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8).copyWith(bottom: 0),
        child: Row(
          children: [
            Text(
              '$title at : ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('yyyy-MMMM-dd : hh-mm-ss EEEE').format(date),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.red),
            ),
          ],
        ),
      );
}
