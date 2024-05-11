import '/exports.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey widgetKey = GlobalKey();

    return AdminScaffold(
      pageName: 'Home',
      body: StreamBuilder(
        stream: users(),
        builder: (context, usersSnapshot) {
          if (usersSnapshot.hasData) {
            return StreamBuilder(
              stream: orders(),
              builder: (context, ordersSnapshot) {
                if (ordersSnapshot.hasData) {
                  return StreamBuilder(
                    stream: products(),
                    builder: (context, productsSnapshot) {
                      if (productsSnapshot.hasData) {
                        return FB5Row(
                          children: [
                            FB5Col(
                              classNames: 'col-12',
                              child: AdminPanelsSection(
                                orders: ordersSnapshot.data!,
                                products: productsSnapshot.data!,
                                clients: usersSnapshot.data!
                                    .where((element) =>
                                        element.role == UserRole.client)
                                    .toList(),
                              ),
                            ),
                            FB5Col(
                              key: widgetKey,
                              classNames: 'col-lg-8 col-md-6 col-sm-12',
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                child: AdminAnaliticsSection(
                                    orders: ordersSnapshot.data!),
                              ),
                            ),
                            FB5Col(
                              classNames: 'col-lg-4 col-md-6 col-sm-12',
                              height: widgetKey.currentContext?.height,
                              child: AdminUsersSection(
                                drivers: usersSnapshot.data!
                                    .where((element) =>
                                        element.address != null &&
                                        element.role == UserRole.driver)
                                    .toList(),
                              ),
                            ),
                            FB5Col(
                              classNames: 'col-12',
                              child: AdminOrdersSection(
                                ordersData: ordersSnapshot.data!,
                                productsData: productsSnapshot.data!,
                              ),
                            ),
                          ],
                        );
                      } else if (productsSnapshot.hasError) {
                        return Center(
                            child: Text(
                          productsSnapshot.error.toString(),
                        ));
                      } else if (productsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else if (ordersSnapshot.hasError) {
                  return Center(
                      child: Text(
                    ordersSnapshot.error.toString(),
                  ));
                } else if (ordersSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else if (usersSnapshot.hasError) {
            return Center(
                child: Text(
              usersSnapshot.error.toString(),
            ));
          } else if (usersSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
