// ignore_for_file: invalid_use_of_protected_member

import '/exports.dart';

String noImage =
    'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/no-photo.jpg?alt=media&token=c63d8351-5eb6-478d-871f-d0c8183af36c';

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse => map.map((k, v) => MapEntry(v, k));
}

errorSnackBar(BuildContext context, String text) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

succesSnackBar(BuildContext context, String text) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF01b075),
          content: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

String toTitleCase(String text) => text
    .replaceAll(RegExp(' +'), ' ')
    .split(' ')
    .map((str) => str[0].toUpperCase() + str.substring(1).toLowerCase())
    .join(' ');

page({required BuildContext context, required Widget page}) {
  PageRouteBuilder route = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: Tween(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      ),
      child: child,
    ),
  );

  return page == const Main()
      ? Navigator.of(context).pushAndRemoveUntil(
          route,
          (Route<dynamic> route) => false,
        )
      : Navigator.of(context).push(route);
}

Color progressColor(OrderProgress progress) {
  Color color;

  switch (progress) {
    case OrderProgress.binding:
      color = Colors.blue;
      break;
    case OrderProgress.inProgress:
      color = const Color(0xFF01b075);
      break;
    case OrderProgress.done:
      color = Colors.grey;
      break;
    case OrderProgress.deleted:
      color = const Color(0xffdc3545);
  }

  return color;
}

String progressDescription(OrderProgress progress) {
  String text;

  switch (progress) {
    case OrderProgress.binding:
      text = 'Waiting the shop to prepare it.';
      break;
    case OrderProgress.inProgress:
      text = 'Waiting the delivey company';
      break;
    case OrderProgress.done:
      text = 'Delivered';
      break;
    case OrderProgress.deleted:
      text = 'Deleted';
      break;
  }

  return text;
}

String paymentDetails(PaymentMethod payment) {
  switch (payment) {
    case PaymentMethod.cash:
      return 'Cash on deliver';
    case PaymentMethod.online:
      return 'Paid by Credit Card';
  }
}
