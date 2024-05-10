import '/exports.dart';

class ClientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageName;
  final bool scrolled, hasDrawer;

  const ClientAppBar({
    super.key,
    required this.pageName,
    required this.scrolled,
    required this.hasDrawer,
  });

  Color color() =>
      pageName == 'home' && !scrolled ? Colors.white : Colors.black;

  @override
  Widget build(BuildContext context) => Material(
        color: pageName == 'home' && !scrolled
            ? Colors.transparent.withOpacity(0.25)
            : Colors.white,
        child: FB5Container(
          child: Row(
            children: [
              // Sort Button
              if (hasDrawer) ...{
                IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.sort),
                )
              },

              // Logo
              TextButton(
                onPressed: () => page(
                  context: context,
                  page: const Main(),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(
                    color(),
                  ),
                  textStyle: MaterialStateProperty.resolveWith(
                    (states) => TextStyle(
                      fontSize: 24,
                      fontWeight: states.contains(MaterialState.hovered) ||
                              states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)
                          ? FontWeight.w900
                          : FontWeight.w400,
                      fontFamily: 'Breathing',
                    ),
                  ),
                ),
                child: Text(App.name),
              ),

              // Menu
              // Left Menu
              if (MediaQuery.sizeOf(context).width >= 900) ...{
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      Genders.values.length,
                      (index) => GetBuilder<SortController>(
                        builder: (controller) {
                          Genders gender = Genders.values[index];

                          return TextButton(
                            onPressed: () {
                              page(
                                context: context,
                                page: const ClientShop(),
                              );

                              controller.gender = gender;
                              controller.update();
                            },
                            style: ButtonStyle(
                              textStyle: MaterialStateProperty.resolveWith(
                                (states) => TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      states.contains(MaterialState.hovered) ||
                                              states.contains(
                                                  MaterialState.focused) ||
                                              states.contains(
                                                  MaterialState.pressed) ||
                                              controller.gender == gender
                                          ? FontWeight.w900
                                          : FontWeight.w400,
                                  color: color(),
                                ),
                              ),
                              foregroundColor: MaterialStatePropertyAll(
                                color(),
                              ),
                            ),
                            child: Text(
                              genders.reverse[gender]!.toUpperCase(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              },
              const Spacer(),

              // Right Menu
              if (MediaQuery.sizeOf(context).width >= 900) ...{
                rightMenuItem(
                  context: context,
                  title: 'about us',
                  widget: const About(),
                ),
                rightMenuItem(
                  context: context,
                  title: 'contact us',
                  widget: const Contact(),
                ),
              },
              GetBuilder<CartController>(
                builder: (controller) => IconButton(
                  onPressed: () => page(
                    context: context,
                    page: const Cart(),
                  ),
                  icon: Badge(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(controller.cartProducts.length.toString()),
                    child: Icon(
                      Icons.shopping_bag,
                      color: color(),
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) => snapshot.hasData
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: PopupMenuButton(
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) =>
                                    Profile(id: snapshot.data!.uid),
                              ),
                              child: const Text('Profile'),
                            ),
                            PopupMenuItem(
                              onTap: () => page(
                                context: context,
                                page: const ClientScaffold(
                                  pageName: 'Orders',
                                  pageImage:
                                      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/title%2Forders.jpeg?alt=media&token=0c23f49a-e5eb-44fb-91db-0e8613fc16aa',
                                  body: Orders(),
                                ),
                              ),
                              child: const Text('Orders'),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                try {
                                  FirebaseAuth.instance
                                      .signOut()
                                      .then((value) => page(
                                            context: context,
                                            page: const Main(),
                                          ));
                                } on FirebaseException catch (error) {
                                  errorSnackBar(
                                      context, error.message.toString());
                                }
                              },
                              child: const Text('Sign Out'),
                            ),
                          ],
                          child: Icon(
                            Icons.person,
                            color: color(),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () => page(
                          context: context,
                          page: const Login(),
                        ),
                        icon: Icon(
                          Icons.login,
                          color: color(),
                        ),
                      ),
              ),

              // Mobile Menu
              if (MediaQuery.sizeOf(context).width <= 900) ...{
                IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: Icon(
                    Icons.menu,
                    color: color(),
                  ),
                ),
              }
            ],
          ),
        ),
      );

  @override
  Size get preferredSize => const Size(double.maxFinite, 75);

  Widget rightMenuItem({
    required BuildContext context,
    required String title,
    required Widget widget,
  }) =>
      TextButton(
        onPressed: () => page(context: context, page: widget),
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 12,
              fontWeight: states.contains(MaterialState.hovered) ||
                      states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed)
                  ? FontWeight.w900
                  : FontWeight.w400,
              color: color(),
            ),
          ),
          foregroundColor: MaterialStatePropertyAll(
            color(),
          ),
        ),
        child: Text(
          title.toUpperCase(),
        ),
      );
}
