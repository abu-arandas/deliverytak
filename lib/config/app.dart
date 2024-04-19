import '/exports.dart';

class App {
  static String name = 'Deliverytak';
  static PhoneNumber phone =
      const PhoneNumber(isoCode: IsoCode.JO, nsn: '791568798');
  static String description =
      'is a cutting-edge mobile application built using Flutter and Firebase, designed to revolutionize the online fashion shopping experience. With its sleek design, seamless user experience, and robust backend powered by Firebase, Fashionista offers both customers and administrators a comprehensive solution for all their fashion needs.';
  static LatLng address = const LatLng(31.9860882, 35.9255499);

  static Widget logo({Color? color}) => FutureBuilder(
        future:
            FirebaseStorage.instance.ref().child('logo.png').getDownloadURL(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              imageUrl: snapshot.data!,
              fit: BoxFit.fill,
              color: color,
            );
          } else if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Container();
          }
        },
      );
}
