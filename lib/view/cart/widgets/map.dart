import '/exports.dart';

class CartMap extends StatelessWidget {
  const CartMap({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<CartController>(
        builder: (controller) => SizedBox(
          height: 400,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: controller.latLng ??
                  LocationController.instance.currentLocation,
              initialZoom: 15,
              onMapEvent: (event) => controller.setLatLng(event.camera.center),
              onTap: (tapPosition, point) => controller.setLatLng(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.arandas.deliverytak',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: controller.latLng ??
                        LocationController.instance.currentLocation,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
