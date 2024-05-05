import '/exports.dart';

class SingleOrderMap extends StatelessWidget {
  final OrderModel order;
  const SingleOrderMap({super.key, required this.order});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: users(),
        builder: (context, snapshot) {
          UserModel? driver;

          if (snapshot.hasData && order.driverId != null) {
            driver = snapshot.data!
                .singleWhere((element) => element.id == order.driverId);
          } else {
            driver = null;
          }

          return SizedBox(
            height: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: order.clientAddress,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.arandas.deliverytak',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: order.clientAddress,
                      child: const Icon(Icons.location_pin),
                    ),
                    if (driver != null) ...{
                      Marker(
                        point: order.clientAddress,
                        child: const Icon(
                          Icons.drive_eta,
                          color: Colors.blue,
                        ),
                      ),
                    }
                  ],
                ),
              ],
            ),
          );
        },
      );
}
