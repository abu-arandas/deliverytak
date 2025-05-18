import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/delivery_provider.dart';
import '../models/delivery.dart';

class DeliveryTrackingPage extends StatefulWidget {
  final String deliveryId;

  const DeliveryTrackingPage({
    super.key,
    required this.deliveryId,
  });

  @override
  State<DeliveryTrackingPage> createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeliveryProvider>().startDeliveryTracking(widget.deliveryId);
    });
  }

  void _updateMapCamera(GeoPoint? location) {
    if (location != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(location.latitude, location.longitude),
        ),
      );
    }
  }

  void _updateMarkers(Delivery delivery) {
    if (delivery.currentLocation != null) {
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('delivery'),
            position: LatLng(
              delivery.currentLocation!.latitude,
              delivery.currentLocation!.longitude,
            ),
            infoWindow: InfoWindow(
              title: 'Delivery Location',
              snippet: delivery.status.toString().split('.').last,
            ),
          ),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Delivery'),
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

          _updateMarkers(delivery);
          _updateMapCamera(delivery.currentLocation);

          return Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: delivery.currentLocation != null
                        ? LatLng(
                            delivery.currentLocation!.latitude,
                            delivery.currentLocation!.longitude,
                          )
                        : const LatLng(0, 0),
                    zoom: 15,
                  ),
                  markers: _markers,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _updateMapCamera(delivery.currentLocation);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Delivery Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildStatusCard(delivery),
                    const SizedBox(height: 16),
                    _buildTimeline(delivery),
                  ],
                ),
              ),
            ],
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
                  'Status: ${delivery.status.toString().split('.').last}',
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
            if (delivery.failureReason != null) ...[
              const SizedBox(height: 8),
              Text(
                'Failure Reason: ${delivery.failureReason}',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
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
