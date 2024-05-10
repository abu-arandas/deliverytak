import '/exports.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  ScrollController scrollController = ScrollController();
  bool scrolled = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(
      () => setState(() {
        scrolled = scrollController.offset >= 10;
      }),
    );

    Geolocator.getPositionStream().listen((position) {
      usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'address': GeoPoint(position.latitude, position.longitude),
      });
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          // Nav Bar
          appBar: PreferredSize(
            preferredSize: const Size(double.maxFinite, 75),
            child: Material(
              color: Colors.white,
              child: FB5Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: RichText(
                    text: TextSpan(
                      text: 'Good ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: DateTime.now().day >= 12
                              ? 'Afternoon'
                              : 'Morning',
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: DateFormat.yMMMEd().format(
                            DateTime.now(),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Body
          body: SingleChildScrollView(
            controller: scrollController,
            child: FB5Container(
              child: StreamBuilder(
                stream: driverOrders(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Panels
                          FB5Row(
                            children: [
                              panel(
                                context: context,
                                icon: Icons.shopping_cart,
                                title: 'Total Orders',
                                data: snapshot.data!.length.toString(),
                              ),
                              panel(
                                context: context,
                                icon: Icons.shopping_cart,
                                title: 'Today Orders',
                                data: snapshot.data!
                                    .where(
                                      (element) {
                                        bool show;

                                        if (element.pickTime != null) {
                                          DateTime pickTime = DateTime(
                                            element.pickTime!.year,
                                            element.pickTime!.month,
                                            element.pickTime!.day,
                                          );
                                          DateTime now = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day,
                                          );

                                          if (pickTime == now) {
                                            show = true;
                                          } else {
                                            show = false;
                                          }
                                        } else {
                                          show = false;
                                        }

                                        return show;
                                      },
                                    )
                                    .length
                                    .toString(),
                              ),
                            ],
                          ),

                          // Orders
                          const Orders(),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      );

  FB5Col panel({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String data,
  }) =>
      FB5Col(
        classNames: 'col-6',
        child: Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary),
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(data, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      );
}
