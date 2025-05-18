import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/delivery_provider.dart';
import '../../models/delivery.dart';

class DriverDeliveryDetailsPage extends StatefulWidget {
  final String deliveryId;

  const DriverDeliveryDetailsPage({
    super.key,
    required this.deliveryId,
  });

  @override
  State<DriverDeliveryDetailsPage> createState() => _DriverDeliveryDetailsPageState();
}

class _DriverDeliveryDetailsPageState extends State<DriverDeliveryDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  DeliveryStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<DeliveryProvider>().startDeliveryTracking(widget.deliveryId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final delivery = context.read<DeliveryProvider>().currentDelivery;
        if (delivery == null) return;

        await context.read<DeliveryProvider>().updateDeliveryStatus(
              deliveryId: widget.deliveryId,
              status: _selectedStatus!,
              message: _messageController.text,
              location: delivery.currentLocation,
            );

        _messageController.clear();
        _selectedStatus = null;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Status updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating status: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
      ),
      body: Consumer<DeliveryProvider>(
        builder: (context, deliveryProvider, child) {
          final delivery = deliveryProvider.currentDelivery;

          if (deliveryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (deliveryProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${deliveryProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      deliveryProvider.clearError();
                      deliveryProvider.startDeliveryTracking(widget.deliveryId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (delivery == null) {
            return const Center(child: Text('No delivery information available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusCard(delivery),
                const SizedBox(height: 24),
                _buildUpdateForm(delivery),
                const SizedBox(height: 24),
                _buildTimeline(delivery),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(Delivery delivery) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Status: ${delivery.status.toString().split('.').last}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusIcon(delivery.status),
              ],
            ),
            if (delivery.estimatedDeliveryTime != null) ...[
              const SizedBox(height: 8),
              Text(
                'Estimated Delivery: ${delivery.estimatedDeliveryTime}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            if (delivery.actualDeliveryTime != null) ...[
              const SizedBox(height: 8),
              Text(
                'Delivered at: ${delivery.actualDeliveryTime}',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateForm(Delivery delivery) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Update Status',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<DeliveryStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'New Status',
                  border: OutlineInputBorder(),
                ),
                items: DeliveryStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Update Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an update message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateStatus,
                child: const Text('Update Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(DeliveryStatus status) {
    IconData iconData;
    Color color;

    switch (status) {
      case DeliveryStatus.pending:
        iconData = Icons.schedule;
        color = Colors.orange;
        break;
      case DeliveryStatus.confirmed:
        iconData = Icons.check_circle;
        color = Colors.blue;
        break;
      case DeliveryStatus.pickedUp:
        iconData = Icons.local_shipping;
        color = Colors.purple;
        break;
      case DeliveryStatus.inTransit:
        iconData = Icons.directions_car;
        color = Colors.indigo;
        break;
      case DeliveryStatus.outForDelivery:
        iconData = Icons.local_shipping;
        color = Colors.deepPurple;
        break;
      case DeliveryStatus.delivered:
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case DeliveryStatus.failed:
        iconData = Icons.error;
        color = Colors.red;
        break;
      case DeliveryStatus.cancelled:
        iconData = Icons.cancel;
        color = Colors.grey;
        break;
    }

    return Icon(iconData, color: color, size: 32);
  }

  Widget _buildTimeline(Delivery delivery) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Timeline',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: delivery.updates.length,
              itemBuilder: (context, index) {
                final update = delivery.updates[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              update.message,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${update.timestamp.hour}:${update.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
