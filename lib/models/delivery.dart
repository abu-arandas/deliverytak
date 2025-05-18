import 'package:cloud_firestore/cloud_firestore.dart';

enum DeliveryStatus { pending, confirmed, pickedUp, inTransit, outForDelivery, delivered, failed, cancelled }

class Delivery {
  final String id;
  final String orderId;
  final String userId;
  final String driverId;
  final DeliveryStatus status;
  final String? trackingNumber;
  final String? estimatedDeliveryTime;
  final String? actualDeliveryTime;
  final String? failureReason;
  final GeoPoint pickup;
  final GeoPoint? currentLocation;
  final List<DeliveryUpdate> updates;
  final DateTime createdAt;
  final DateTime updatedAt;

  Delivery({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.driverId,
    required this.status,
    this.trackingNumber,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.failureReason,
    required this.pickup,
    this.currentLocation,
    required this.updates,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'] as String,
      orderId: map['orderId'] as String,
      userId: map['userId'] as String,
      driverId: map['driverId'] as String,
      status: DeliveryStatus.values.firstWhere(
        (e) => e.toString() == 'DeliveryStatus.${map['status']}',
      ),
      trackingNumber: map['trackingNumber'] as String?,
      estimatedDeliveryTime: map['estimatedDeliveryTime'] as String?,
      actualDeliveryTime: map['actualDeliveryTime'] as String?,
      failureReason: map['failureReason'] as String?,
      pickup: map['pickup'] as GeoPoint,
      currentLocation: map['currentLocation'] as GeoPoint?,
      updates: (map['updates'] as List<dynamic>).map((e) => DeliveryUpdate.fromMap(e as Map<String, dynamic>)).toList(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'userId': userId,
      'driverId': driverId,
      'status': status.toString().split('.').last,
      'trackingNumber': trackingNumber,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'actualDeliveryTime': actualDeliveryTime,
      'failureReason': failureReason,
      'pickup': pickup,
      'currentLocation': currentLocation,
      'updates': updates.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Delivery copyWith({
    String? id,
    String? orderId,
    String? userId,
    String? driverId,
    DeliveryStatus? status,
    String? trackingNumber,
    String? estimatedDeliveryTime,
    String? actualDeliveryTime,
    String? failureReason,
    GeoPoint? pickup,
    GeoPoint? currentLocation,
    List<DeliveryUpdate>? updates,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Delivery(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      status: status ?? this.status,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
      failureReason: failureReason ?? this.failureReason,
      pickup: pickup ?? this.pickup,
      currentLocation: currentLocation ?? this.currentLocation,
      updates: updates ?? this.updates,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DeliveryUpdate {
  final DeliveryStatus status;
  final String message;
  final DateTime timestamp;
  final GeoPoint? location;

  DeliveryUpdate({
    required this.status,
    required this.message,
    required this.timestamp,
    this.location,
  });

  factory DeliveryUpdate.fromMap(Map<String, dynamic> map) {
    return DeliveryUpdate(
      status: DeliveryStatus.values.firstWhere(
        (e) => e.toString() == 'DeliveryStatus.${map['status']}',
      ),
      message: map['message'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      location: map['location'] as GeoPoint?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.toString().split('.').last,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'location': location,
    };
  }
}
