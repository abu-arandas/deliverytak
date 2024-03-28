import '/exports.dart';

class OrderModel {
  String id;
  String clientId;
  DateTime startTime;
  LatLng clientAddress;
  List<ProductModel> products;
  DateTime? acceptTime, endTime;
  PaymentMethod payment;
  OrderProgress progress;

  OrderModel({
    required this.id,
    required this.clientId,
    required this.startTime,
    required this.clientAddress,
    required this.products,
    required this.payment,
    this.acceptTime,
    this.endTime,
    required this.progress,
  });

  factory OrderModel.fromJson(DocumentSnapshot data) => OrderModel(
        id: data.id,
        clientId: data['clientId'],
        startTime: (data['startTime'] as Timestamp).toDate(),
        clientAddress: LatLng.fromJson(data['clientAddress']),
        products: List.generate(
          data['products'].length,
          (index) => ProductModel.fromJson(data['products'][index]),
        ),
        payment: paymentMethod.map[data['payment']]!,
        acceptTime: data['acceptTime'] != null
            ? (data['acceptTime'] as Timestamp).toDate()
            : null,
        endTime: data['endTime'] != null
            ? (data['endTime'] as Timestamp).toDate()
            : null,
        progress: orderProgress.map[data['progress']]!,
      );

  Map<String, dynamic> toJson() => {
        'clientId': clientId,
        'startTime': startTime,
        'clientAddress': clientAddress.toJson(),
        'products':
            List.generate(products.length, (index) => products[index].toJson()),
        'payment': paymentMethod.reverse[payment],
        'acceptTime': acceptTime,
        'endTime': endTime,
        'progress': orderProgress.reverse[progress],
      };
}

enum OrderProgress { binding, inProgress, done }

EnumValues<OrderProgress> orderProgress = EnumValues({
  'Binding': OrderProgress.binding,
  'In Progress': OrderProgress.inProgress,
  'Done': OrderProgress.done,
});

enum PaymentMethod { cash, online }

EnumValues<PaymentMethod> paymentMethod =
    EnumValues({'Cash': PaymentMethod.cash, 'Online': PaymentMethod.online});
