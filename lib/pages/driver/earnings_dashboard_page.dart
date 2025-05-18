import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/earnings_provider.dart';
import '../../providers/auth_provider.dart';

class DriverEarningsDashboardPage extends StatefulWidget {
  const DriverEarningsDashboardPage({super.key});

  @override
  State<DriverEarningsDashboardPage> createState() => _DriverEarningsDashboardPageState();
}

class _DriverEarningsDashboardPageState extends State<DriverEarningsDashboardPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final driverId = context.read<AuthProvider>().currentUser?.id;
    if (driverId == null) return;

    await context.read<EarningsProvider>().loadEarningsSummary(driverId);
    await context.read<EarningsProvider>().loadEarningsByPeriod(
          driverId,
          _startDate,
          _endDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings Dashboard'),
      ),
      body: Consumer<EarningsProvider>(
        builder: (context, earningsProvider, child) {
          if (earningsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (earningsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${earningsProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      earningsProvider.clearError();
                      _loadData();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final summary = earningsProvider.earningsSummary;
          if (summary == null) {
            return const Center(child: Text('No earnings data available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSummaryCards(summary),
                const SizedBox(height: 24),
                _buildDateRangePicker(),
                const SizedBox(height: 24),
                _buildEarningsChart(earningsProvider.periodEarnings),
                const SizedBox(height: 24),
                _buildEarningsList(earningsProvider.earnings),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> summary) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          'Total Earnings',
          '\$${summary['totalEarnings'].toStringAsFixed(2)}',
          Colors.blue,
        ),
        _buildSummaryCard(
          'Completed',
          '\$${summary['completedEarnings'].toStringAsFixed(2)}',
          Colors.green,
        ),
        _buildSummaryCard(
          'Pending',
          '\$${summary['pendingEarnings'].toStringAsFixed(2)}',
          Colors.orange,
        ),
        _buildSummaryCard(
          'Total Deliveries',
          summary['totalDeliveries'].toString(),
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

  Widget _buildDateRangePicker() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date Range',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                        _loadData();
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_startDate.toString().split(' ')[0]),
                  ),
                ),
                const Text('to'),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                        _loadData();
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_endDate.toString().split(' ')[0]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsChart(List<Map<String, dynamic>> periodEarnings) {
    if (periodEarnings.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No earnings data for the selected period'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Earnings Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= periodEarnings.length) {
                            return const Text('');
                          }
                          final date = periodEarnings[value.toInt()]['date'];
                          return Text(
                            date.split('-')[2],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: periodEarnings.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value['totalEarnings'].toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
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

  Widget _buildEarningsList(List<dynamic> earnings) {
    if (earnings.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No earnings records found'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Earnings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: earnings.length,
              itemBuilder: (context, index) {
                final earning = earnings[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: earning.status == 'completed' ? Colors.green : Colors.orange,
                    child: Icon(
                      earning.status == 'completed' ? Icons.check : Icons.pending,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Delivery #${earning.deliveryId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${earning.date.toString().split(' ')[0]} - ${earning.status}',
                  ),
                  trailing: Text(
                    '\$${earning.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
