import '/exports.dart';

class AdminSideSection extends StatelessWidget {
  final String pageName;
  const AdminSideSection({super.key, required this.pageName});

  Widget tile({
    required IconData icon,
    required String title,
    void Function()? onTap,
  }) =>
      ListTile(
        selected: pageName.toLowerCase() == title.toLowerCase(),
        shape: const RoundedRectangleBorder(),
        onTap: onTap,
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.sizeOf(context).height,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            App.logo(color: Colors.black),
            const SizedBox(height: 24),
            tile(
              icon: Icons.home,
              title: 'Home',
              onTap: () => page(
                context: context,
                page: const AdminHome(),
              ),
            ),
            tile(
              icon: Icons.store,
              title: 'Shop',
              onTap: () => page(
                context: context,
                page: const AdminShop(),
              ),
            ),
            tile(
              icon: Icons.history,
              title: 'Orders',
              onTap: () => page(
                context: context,
                page: const AdminScaffold(
                  pageName: 'Orders',
                  body: Orders(),
                ),
              ),
            ),
            const Spacer(),
            tile(
              icon: Icons.logout,
              title: 'Sign Out',
              onTap: () {
                try {
                  FirebaseAuth.instance.signOut().then((value) => page(
                        context: context,
                        page: const Main(),
                      ));
                } catch (error) {
                  errorSnackBar(
                    context,
                    error.toString(),
                  );
                }
              },
            ),
          ],
        ),
      );
}
