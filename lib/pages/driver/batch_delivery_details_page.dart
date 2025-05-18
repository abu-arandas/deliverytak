import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

import '../../providers/batch_delivery_provider.dart';
import '../../models/batch_delivery.dart';
import '../../models/delivery.dart';
import '../../models/batch_delivery_details.dart';

class BatchDeliveryDetailsPage extends StatefulWidget {
  final String batchId;

  const BatchDeliveryDetailsPage({
    super.key,
    required this.batchId,
  });

  @override
  State<BatchDeliveryDetailsPage> createState() => _BatchDeliveryDetailsPageState();
}

class _BatchDeliveryDetailsPageState extends State<BatchDeliveryDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<BatchDeliveryProvider>().loadBatchDelivery(widget.batchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Details'),
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

          final batch = provider.currentBatch;
          final details = provider.currentBatchDetails;

          if (batch == null || details == null) {
            return const Center(
              child: Text('Batch not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBatchInfo(batch),
                const SizedBox(height: 24),
                _buildRouteMap(details),
                const SizedBox(height: 24),
                _buildDeliveriesList(details.deliveries),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBatchInfo(BatchDelivery batch) {
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
                  'Batch #${batch.id}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(batch.status),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Created', batch.createdAt.toString().split('.')[0]),
            _buildInfoRow('Total Deliveries', batch.deliveryIds.length.toString()),
            _buildInfoRow('Total Distance', '${batch.totalDistance?.toStringAsFixed(2)} km'),
            _buildInfoRow(
              'Estimated Duration',
              '${(batch.estimatedDuration ?? 1 / 60).toStringAsFixed(0)} minutes',
            ),
            if (batch.notes != null) _buildInfoRow('Notes', batch.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteMap(BatchDeliveryDetails details) {
    return Card(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              details.deliveries.first.pickup.latitude,
              details.deliveries.first.pickup.longitude,
            ),
            zoom: 12,
          ),
          markers: _createMarkers(details.deliveries),
          polylines: _createPolylines(details.route),
          onMapCreated: (controller) {
            _fitBounds(controller, details.deliveries);
          },
        ),
      ),
    );
  }

  Set<Marker> _createMarkers(List<Delivery> deliveries) {
    return deliveries.asMap().entries.map((entry) {
      final delivery = entry.value;
      final index = entry.key;
      return Marker(
        markerId: MarkerId('delivery_$index'),
        position: LatLng(delivery.pickup.latitude, delivery.pickup.longitude),
        infoWindow: InfoWindow(title: 'Delivery #${delivery.id}'),
      );
    }).toSet();
  }

  Set<Polyline> _createPolylines(List<Map<String, dynamic>> route) {
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: route.expand((leg) {
          final steps = leg['steps'] as List;
          return steps.expand((step) {
            final points = step['polyline']['points'] as String;
            return _decodePolyline(points);
          });
        }).toList(),
        color: Colors.blue,
        width: 5,
      ),
    };
  }

  void _fitBounds(GoogleMapController controller, List<Delivery> deliveries) {
    if (deliveries.isEmpty) return;

    final bounds = deliveries.fold<LatLngBounds>(
      LatLngBounds(
        southwest: LatLng(deliveries.first.pickup.latitude, deliveries.first.pickup.longitude),
        northeast: LatLng(deliveries.first.pickup.latitude, deliveries.first.pickup.longitude),
      ),
      (bounds, delivery) {
        final lat = delivery.pickup.latitude;
        final lng = delivery.pickup.longitude;
        return LatLngBounds(
          southwest: LatLng(
            min(bounds.southwest.latitude, lat),
            min(bounds.southwest.longitude, lng),
          ),
          northeast: LatLng(
            max(bounds.northeast.latitude, lat),
            max(bounds.northeast.longitude, lng),
          ),
        );
      },
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }

  Widget _buildDeliveriesList(List<Delivery> deliveries) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deliveries',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deliveries.length,
              itemBuilder: (context, index) {
                final delivery = deliveries[index];
                return _buildDeliveryItem(delivery, index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryItem(Delivery delivery, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(index.toString()),
        ),
        title: Text('Delivery #${delivery.id}'),
        subtitle: Text(delivery.status.toString()),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/delivery-details',
              arguments: delivery.id,
            );
          },
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
}
