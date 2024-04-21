import '/exports.dart';

class LocationController extends GetxController {
  static LocationController instance = Get.find();

  @override
  void onInit() {
    super.onInit();

    permission();
  }

  LatLng currentLocation = App.address;

  permission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }

    if (serviceEnabled &&
        permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      currentAddress();
    }
  }

  currentAddress() => Geolocator.getPositionStream().listen((position) {
        currentLocation = LatLng(position.latitude, position.longitude);
        update();
      });
}
