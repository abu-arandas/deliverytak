import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../../providers/route_optimization_provider.dart';

class OptimizedRoutePage extends StatefulWidget {
  final String deliveryId;
  final List<GeoPoint> waypoints;
  final GeoPoint origin;
  final GeoPoint destination;

  const OptimizedRoutePage({
    super.key,
    required this.deliveryId,
    required this.waypoints,
    required this.origin,
    required this.destination,
  });

  @override
  OptimizedRoutePageState createState() => OptimizedRoutePageState();
}

class OptimizedRoutePageState extends State<OptimizedRoutePage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _optimizeRoute();
  }

  Future<void> _optimizeRoute() async {
    final provider = context.read<RouteOptimizationProvider>();
    await provider.optimizeRoute(
      waypoints: widget.waypoints,
      origin: widget.origin,
      destination: widget.destination,
    );

    if (provider.optimizedRoute != null) {
      _updateMapWithRoute(provider.optimizedRoute!);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _updateMapWithRoute(List<Map<String, dynamic>> route) {
    final markers = <Marker>{};
    final polylines = <Polyline>{};

    // Add origin marker
    markers.add(
      Marker(
        markerId: const MarkerId('origin'),
        position: LatLng(widget.origin.latitude, widget.origin.longitude),
        infoWindow: const InfoWindow(title: 'Origin'),
      ),
    );

    // Add destination marker
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.destination.latitude, widget.destination.longitude),
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );

    // Add waypoint markers
    for (var i = 0; i < widget.waypoints.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('waypoint_$i'),
          position: LatLng(
            widget.waypoints[i].latitude,
            widget.waypoints[i].longitude,
          ),
          infoWindow: InfoWindow(title: 'Waypoint ${i + 1}'),
        ),
      );
    }

    // Add route polylines
    for (var i = 0; i < route.length; i++) {
      final leg = route[i];
      final steps = leg['steps'] as List;
      final points = <LatLng>[];

      for (var step in steps) {
        final polyline = step['polyline']['points'] as String;
        points.addAll(_decodePolyline(polyline));
      }

      polylines.add(
        Polyline(
          polylineId: PolylineId('route_$i'),
          points: points,
          color: Colors.blue,
          width: 5,
        ),
      );
    }

    setState(() {
      _markers = markers;
      _polylines = polylines;
    });

    // Fit map bounds to show all markers
    if (_mapController != null) {
      _fitMapBounds();
    }
  }

  void _fitMapBounds() {
    if (_markers.isEmpty) return;

    final bounds = _markers.fold<LatLngBounds>(
      LatLngBounds(
        southwest: _markers.first.position,
        northeast: _markers.first.position,
      ),
      (bounds, marker) {
        final southwest = LatLng(
          min(bounds.southwest.latitude, marker.position.latitude),
          min(bounds.southwest.longitude, marker.position.longitude),
        );
        final northeast = LatLng(
          max(bounds.northeast.latitude, marker.position.latitude),
          max(bounds.northeast.longitude, marker.position.longitude),
        );
        return LatLngBounds(southwest: southwest, northeast: northeast);
      },
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
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

      final p = LatLng(lat / 1E5, lng / 1E5);
      poly.add(p);
    }

    return poly;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RouteOptimizationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Optimized Route'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _optimizeRoute();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.origin.latitude, widget.origin.longitude),
              zoom: 12,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) {
              _mapController = controller;
              if (!_isLoading) {
                _fitMapBounds();
              }
            },
          ),
          if (_isLoading || provider.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (provider.error != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: provider.clearError,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
