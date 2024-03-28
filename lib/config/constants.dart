import '/exports.dart';

String noImage =
    'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/no-photo.jpg?alt=media&token=c63d8351-5eb6-478d-871f-d0c8183af36c';

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse => map.map((k, v) => MapEntry(v, k));
}

errorSnackBar(String text) => ScaffoldMessenger.of(Get.context!)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(Get.context!).colorScheme.error,
      content: Text(text, style: const TextStyle(color: Colors.white)),
    ),
  );

succesSnackBar(String text) => ScaffoldMessenger.of(Get.context!)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      backgroundColor: const Color(0xFF01b075),
      content: Text(text, style: const TextStyle(color: Colors.white)),
    ),
  );

String toTitleCase(String text) => text
    .replaceAll(RegExp(' +'), ' ')
    .split(' ')
    .map((str) => str[0].toUpperCase() + str.substring(1).toLowerCase())
    .join(' ');

Widget title(context, String text) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 50,
            height: 2,
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.only(top: 8, bottom: 32),
          ),
        ],
      ),
    );

Widget pageTtitle({
  required BuildContext context,
  required String text,
  required String bg,
  Widget? addition,
}) =>
    Container(
      width: double.maxFinite,
      height: 300,
      padding: const EdgeInsets.all(64),
      margin: const EdgeInsets.only(bottom: 32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bg),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.darken),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          if (addition != null) addition
        ],
      ),
    );
