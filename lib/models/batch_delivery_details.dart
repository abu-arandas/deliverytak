import 'delivery.dart';

class BatchDeliveryDetails {
  final String batchId;
  final List<Delivery> deliveries;
  final List<Map<String, dynamic>> route;
  final double totalDistance;
  final int estimatedDuration;

  BatchDeliveryDetails({
    required this.batchId,
    required this.deliveries,
    required this.route,
    required this.totalDistance,
    required this.estimatedDuration,
  });

  factory BatchDeliveryDetails.fromMap(Map<String, dynamic> map) {
    return BatchDeliveryDetails(
      batchId: map['batchId'] as String,
      deliveries:
          (map['deliveries'] as List).map((delivery) => Delivery.fromMap(delivery as Map<String, dynamic>)).toList(),
      route: List<Map<String, dynamic>>.from(map['route'] as List),
      totalDistance: (map['totalDistance'] as num).toDouble(),
      estimatedDuration: map['estimatedDuration'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'batchId': batchId,
      'deliveries': deliveries.map((delivery) => delivery.toMap()).toList(),
      'route': route,
      'totalDistance': totalDistance,
      'estimatedDuration': estimatedDuration,
    };
  }
}
