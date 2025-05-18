import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/delivery_schedule_provider.dart';
import '../../models/delivery_schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  String deliveryId = '';
  TimeOfDay? scheduledTime;
  String notes = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = context.read<DeliveryScheduleProvider>();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    await provider.loadSchedulesByDateRange(
      driverId: currentUser.uid,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Consumer<DeliveryScheduleProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      _loadData();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.schedules.isEmpty) {
            return const Center(
              child: Text('No schedules found for the selected date range.'),
            );
          }

          return Column(
            children: [
              _buildDateRangePicker(context, provider),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = provider.schedules[index];
                    return _buildScheduleCard(context, schedule, provider);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Schedule'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Delivery ID'),
                    onChanged: (value) => deliveryId = value,
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => scheduledTime = time);
                      }
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(scheduledTime?.format(context) ?? 'Select Time'),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                    onChanged: (value) => notes = value,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (deliveryId.isNotEmpty && scheduledTime != null) {
                      final provider = context.read<DeliveryScheduleProvider>();
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        provider.createSchedule(
                          driverId: currentUser.uid,
                          deliveryId: deliveryId,
                          scheduledTime: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            scheduledTime!.hour,
                            scheduledTime!.minute,
                          ),
                          notes: notes,
                        );
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateRangePicker(
    BuildContext context,
    DeliveryScheduleProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2025),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                        _loadData();
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      DateFormat('MMM dd, yyyy').format(_startDate),
                    ),
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
                        lastDate: DateTime(2025),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                        _loadData();
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      DateFormat('MMM dd, yyyy').format(_endDate),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(
    BuildContext context,
    DeliverySchedule schedule,
    DeliveryScheduleProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(
          'Delivery #${schedule.deliveryId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scheduled: ${DateFormat('MMM dd, yyyy HH:mm').format(schedule.scheduledTime)}',
            ),
            if (schedule.actualTime != null)
              Text(
                'Actual: ${DateFormat('MMM dd, yyyy HH:mm').format(schedule.actualTime!)}',
              ),
            Text('Status: ${schedule.status}'),
            if (schedule.notes != null) Text('Notes: ${schedule.notes}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            switch (value) {
              case 'update_status':
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Update Status'),
                    content: DropdownButtonFormField<String>(
                      value: schedule.status,
                      items: ['Scheduled', 'In Progress', 'Completed', 'Cancelled']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null && newStatus != schedule.status) {
                          provider.updateScheduleStatus(
                            scheduleId: schedule.id,
                            status: schedule.status,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                );
                break;
              case 'cancel':
                await provider.cancelSchedule(schedule.id);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'update_status',
              child: Text('Update Status'),
            ),
            const PopupMenuItem(
              value: 'cancel',
              child: Text('Cancel Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
