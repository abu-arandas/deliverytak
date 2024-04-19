import '/exports.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  Widget tile({
    required String title,
    required String data,
    void Function()? onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '$title :',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Flexible(
              child: Text(
                data,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    GlobalKey key = GlobalKey();

    return ClientScaffold(
      pageName: 'contact us',
      pageImage:
          'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/title%2Famman.jpg?alt=media&token=645b847a-306a-47db-a17e-20b8cd63d0be',
      body: FB5Container(
        child: FB5Row(
          children: [
            // Informations
            FB5Col(
              key: key,
              classNames: 'col-lg-5 col-md-6 col-sm-12 p-3',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact us with any questions you may have. We will get back to you within 24 hour.',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Divider(thickness: 2.5, color: Colors.grey),
                  ),
                  tile(
                    title: 'Address',
                    data: 'Amman, Jordan',
                    onTap: () async => await launchUrl(
                      Uri.parse(
                          'https://www.google.com/maps/@${App.address.latitude},${App.address.longitude}z?entry=ttu'),
                    ),
                  ),
                  tile(
                    title: 'Tel',
                    data: '(${App.phone.countryCode}) ${App.phone.nsn}',
                    onTap: () async => await launchUrl(
                      Uri.parse('tel:${App.phone.international}'),
                    ),
                  ),
                  tile(
                    title: 'WEB',
                    data: 'Ehab Arandas',
                    onTap: () async => await launchUrl(
                      Uri.parse('https://web.facebook.com/abu00arandas/'),
                    ),
                  ),
                ],
              ),
            ),

            // Map
            FB5Col(
              classNames: 'col-lg-7 col-md-6 col-sm-12',
              child: SizedBox(
                height: key.currentContext != null
                    ? key.currentContext!.height
                    : 300,
                child: FlutterMap(
                  options:
                      MapOptions(initialCenter: App.address, initialZoom: 15),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.arandas.deliverytak',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: App.address,
                          child:
                              const Icon(Icons.location_pin, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
