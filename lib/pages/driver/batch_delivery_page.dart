import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/batch_delivery_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/batch_delivery.dart';

class BatchDeliveryPage extends StatefulWidget {
  const BatchDeliveryPage({super.key});

  @override
  State<BatchDeliveryPage> createState() => _BatchDeliveryPageState();
}

class _BatchDeliveryPageState extends State<BatchDeliveryPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final driverId = context.read<AuthProvider>().currentUser?.id;
    if (driverId == null) return;

    context.read<BatchDeliveryProvider>().startBatchTracking(driverId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Deliveries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Consumer<BatchDeliveryProvider>(
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
                  const SizedBox(height: 16),
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

          if (provider.batchDeliveries.isEmpty) {
            return const Center(
              child: Text('No batch deliveries found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.batchDeliveries.length,
            itemBuilder: (context, index) {
              final batch = provider.batchDeliveries[index];
              return _buildBatchDeliveryCard(batch);
            },
          );
        },
      ),
    );
  }

  Widget _buildBatchDeliveryCard(BatchDelivery batch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Batch #${batch.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(batch.status),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Created: ${batch.createdAt.toString().split('.')[0]}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Deliveries: ${batch.deliveryIds.length}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Distance: ${batch.totalDistance?.toStringAsFixed(2)} km',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated Duration: ${(batch.estimatedDuration ?? 1 / 60).toStringAsFixed(0)} minutes',
              style: const TextStyle(color: Colors.grey),
            ),
            if (batch.notes != null) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${batch.notes}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (batch.status == 'pending')
                  ElevatedButton(
                    onPressed: () => _startBatch(batch),
                    child: const Text('Start Batch'),
                  ),
                if (batch.status == 'in_progress')
                  ElevatedButton(
                    onPressed: () => _completeBatch(batch),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Complete Batch'),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _viewBatchDetails(batch),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'in_progress':
        color = Colors.blue;
        label = 'In Progress';
        break;
      case 'completed':
        color = Colors.green;
        label = 'Completed';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  Future<void> _startBatch(BatchDelivery batch) async {
    try {
      await context.read<BatchDeliveryProvider>().updateBatchStatus(
            batchId: batch.id,
            status: 'in_progress',
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting batch: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _completeBatch(BatchDelivery batch) async {
    try {
      await context.read<BatchDeliveryProvider>().updateBatchStatus(
            batchId: batch.id,
            status: 'completed',
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error completing batch: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _viewBatchDetails(BatchDelivery batch) {
    Navigator.pushNamed(
      context,
      '/batch-delivery-details',
      arguments: batch.id,
    );
  }
}
