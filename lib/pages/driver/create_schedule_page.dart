import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/delivery_schedule_provider.dart';

class CreateSchedulePage extends StatefulWidget {
  const CreateSchedulePage({super.key});

  @override
  State<CreateSchedulePage> createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _deliveryIdController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _scheduledTime = DateTime.now();
  Duration _estimatedDuration = const Duration(hours: 1);

  @override
  void dispose() {
    _deliveryIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_scheduledTime),
      );

      if (time != null) {
        setState(() {
          _scheduledTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _selectDuration() async {
    final hours = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 8; i++)
              ListTile(
                title: Text('$i hour${i > 1 ? 's' : ''}'),
                onTap: () => Navigator.pop(context, i),
              ),
          ],
        ),
      ),
    );

    if (hours != null) {
      setState(() {
        _estimatedDuration = Duration(hours: hours);
      });
    }
  }

  Future<void> _createSchedule() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DeliveryScheduleProvider>();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final hasConflict = await provider.checkForConflicts(
      driverId: currentUser.uid,
      scheduledTime: _scheduledTime,
      estimatedDuration: _estimatedDuration,
    );

    if (hasConflict) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Schedule Conflict'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('This schedule conflicts with the following deliveries:'),
              const SizedBox(height: 8),
              ...provider.conflicts.map((schedule) => ListTile(
                    title: Text('Delivery #${schedule.deliveryId}'),
                    subtitle: Text(
                      'Scheduled: ${DateFormat('MMM dd, yyyy HH:mm').format(schedule.scheduledTime)}',
                    ),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _submitSchedule();
              },
              child: const Text('Schedule Anyway'),
            ),
          ],
        ),
      );
    } else {
      _submitSchedule();
    }
  }

  Future<void> _submitSchedule() async {
    final provider = context.read<DeliveryScheduleProvider>();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    await provider.createSchedule(
      deliveryId: _deliveryIdController.text,
      driverId: currentUser.uid,
      scheduledTime: _scheduledTime,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    if (!mounted) return;
    if (provider.error == null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Schedule'),
      ),
      body: Consumer<DeliveryScheduleProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _deliveryIdController,
                    decoration: const InputDecoration(
                      labelText: 'Delivery ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a delivery ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Scheduled Time'),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy HH:mm').format(_scheduledTime),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _selectDateTime,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text('Estimated Duration'),
                    subtitle: Text(
                      '${_estimatedDuration.inHours} hour${_estimatedDuration.inHours > 1 ? 's' : ''}',
                    ),
                    trailing: const Icon(Icons.timer),
                    onTap: _selectDuration,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  if (provider.error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _createSchedule,
                    child: const Text('Create Schedule'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
