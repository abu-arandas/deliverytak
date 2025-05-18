import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/order.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrderProvider>().fetchAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Consumer3<OrderProvider, ProductProvider, AdminProvider>(
              builder: (context, orderProvider, productProvider, adminProvider, child) {
                if (orderProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (orderProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          orderProvider.error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            orderProvider.clearError();
                            orderProvider.fetchAllOrders();
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                final orders = orderProvider.orders;
                final totalRevenue = orders.fold<double>(
                  0,
                  (sum, order) => sum + (order.totalAmount),
                );
                final totalOrders = orders.length;
                final averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMetricCard(
                      'Total Revenue',
                      '\$${totalRevenue.toStringAsFixed(2)}',
                      Icons.attach_money,
                      Colors.green,
                    ),
                    _buildMetricCard(
                      'Total Orders',
                      totalOrders.toString(),
                      Icons.shopping_cart,
                      Colors.blue,
                    ),
                    _buildMetricCard(
                      'Average Order Value',
                      '\$${averageOrderValue.toStringAsFixed(2)}',
                      Icons.analytics,
                      Colors.orange,
                    ),
                    _buildMetricCard(
                      'Active Products',
                      productProvider.products.length.toString(),
                      Icons.inventory,
                      Colors.purple,
                    ),
                    _buildOrdersByStatusChart(orders),
                    _buildRevenueByMonthChart(orders),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersByStatusChart(List<Order> orders) {
    final statusCounts = <String, int>{};
    for (final order in orders) {
      statusCounts[order.status] = (statusCounts[order.status] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Orders by Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: statusCounts.entries.map((entry) {
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '${entry.key}\n${entry.value}',
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueByMonthChart(List<Order> orders) {
    final monthlyRevenue = <DateTime, double>{};
    for (final order in orders) {
      final month = DateTime(
        order.createdAt.year,
        order.createdAt.month,
      );
      monthlyRevenue[month] = (monthlyRevenue[month] ?? 0) + order.totalAmount;
    }

    final sortedMonths = monthlyRevenue.keys.toList()..sort((a, b) => a.compareTo(b));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue by Month',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: sortedMonths.map((month) {
                        return FlSpot(
                          month.millisecondsSinceEpoch.toDouble(),
                          monthlyRevenue[month]!,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
