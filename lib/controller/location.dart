import '/exports.dart';

class LocationController extends GetxController {
  static LocationController instance = Get.find();

  @override
  void onInit() {
    super.onInit();

    permission();
  }

  LatLng? currentLocation;

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

  currentAddress() =>
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((position) {
        currentLocation = LatLng(position.latitude, position.longitude);
        update();
      });

  double calculateDistance(LatLng first, LatLng second) =>
      Geolocator.distanceBetween(
        first.latitude,
        first.longitude,
        second.latitude,
        second.longitude,
      );

  Future<String> addressTitle({required LatLng address}) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(address.latitude, address.longitude);

    return '${placemarks.first.subLocality ?? ''}, ${placemarks.first.street ?? ''}';
  }
}
