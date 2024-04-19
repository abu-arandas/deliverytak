import '/exports.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminAnaliticsSection extends StatelessWidget {
  final List<OrderModel> orders;
  const AdminAnaliticsSection({super.key, required this.orders});

  List<OrderModel> sortedOrders(DateTime month) => orders
      .where(
        (element) =>
            DateTime(element.startTime.year, element.startTime.month) ==
            DateTime(DateTime.now().year, month.month),
      )
      .toList();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <LineSeries<Map<String, dynamic>, String>>[
            LineSeries<Map<String, dynamic>, String>(
              dataSource: <Map<String, dynamic>>[
                {
                  'month': 'Jan',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.january),
                  ).length,
                },
                {
                  'month': 'Feb',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.february),
                  ).length,
                },
                {
                  'month': 'Mar',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.march),
                  ).length,
                },
                {
                  'month': 'Apr',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.april),
                  ).length,
                },
                {
                  'month': 'May',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.may),
                  ).length,
                },
                {
                  'month': 'Jun',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.june),
                  ).length,
                },
                {
                  'month': 'Jul',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.july),
                  ).length,
                },
                {
                  'month': 'Aug',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.august),
                  ).length,
                },
                {
                  'month': 'Sep',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.september),
                  ).length,
                },
                {
                  'month': 'Oct',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.october),
                  ).length,
                },
                {
                  'month': 'Nov',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.november),
                  ).length,
                },
                {
                  'month': 'Dec',
                  'sales': sortedOrders(
                    DateTime(DateTime.now().year, DateTime.december),
                  ).length,
                },
              ],
              xValueMapper: (Map<String, dynamic> sales, index) =>
                  sales['month'],
              yValueMapper: (Map<String, dynamic> sales, index) =>
                  sales['sales'],
            )
          ],
        ),
      );
}
