import '/exports.dart';

class ClientScaffold extends StatelessWidget {
  const ClientScaffold({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<ScaffoldController>(
        builder: (controller) => Scaffold(
          key: controller.scaffoldKey,

          // Nav Bar
          appBar: AppBar(
            toolbarHeight: 75,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: TextButton(
              onPressed: () =>
                  controller.setPage(name: 'home', widget: const ClientHome()),
              style: ButtonStyle(
                foregroundColor: MaterialStateColor.resolveWith(
                  (states) => states.contains(MaterialState.hovered) ||
                          states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed)
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
                textStyle: MaterialStateTextStyle.resolveWith(
                  (states) => const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Breathing',
                  ),
                ),
              ),
              child: Text(App.name),
            ),
            actions: [
              // Favorite
              IconButton(
                onPressed: () => controller.setPage(
                    name: 'favorite', widget: const Favorite()),
                icon: GetBuilder<ProductController>(
                  init: ProductController(),
                  builder: (controller) => Badge(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(controller.favoriteProducts.length.toString()),
                    child: const Icon(Icons.favorite),
                  ),
                ),
              ),

              // Cart
              IconButton(
                onPressed: () =>
                    controller.setPage(name: 'cart', widget: const Cart()),
                icon: GetBuilder<ProductController>(
                  init: ProductController(),
                  builder: (controller) => Badge(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(controller.cartProducts.length.toString()),
                    child: const Icon(Icons.shopping_bag),
                  ),
                ),
              ),

              // Profile | Menu
              StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return StreamBuilder(
                      stream: UserController.instance
                          .singletUser(snapshot.data!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () => controller.scaffoldKey.currentState!
                                .openEndDrawer(),
                            child: Container(
                              width: 35,
                              height: 35,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent.withOpacity(0.75),
                              ),
                              child: Container(
                                width: double.maxFinite,
                                height: double.maxFinite,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(snapshot.data!.image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return IconButton(
                            onPressed: () => controller
                                .scaffoldKey.currentState!
                                .openEndDrawer(),
                            icon: const Icon(Icons.menu),
                          );
                        }
                      },
                    );
                  } else {
                    return IconButton(
                      onPressed: () =>
                          controller.scaffoldKey.currentState!.openEndDrawer(),
                      icon: const Icon(Icons.menu),
                    );
                  }
                },
              ),
            ],
          ),

          // Drawer
          drawer: controller.drawer,

          // Menu
          endDrawer: Drawer(
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authSnapshot) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // User Data
                  if (authSnapshot.hasData) ...{
                    StreamBuilder(
                      stream: UserController.instance
                          .singletUser(authSnapshot.data!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              // Edit
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton.outlined(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => authSnapshot.hasData
                                        ? Profile(user: snapshot.data!)
                                        : const Login(),
                                  ),
                                  icon: const Icon(Icons.edit),
                                ),
                              ),

                              // Image
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(snapshot.data!.image),
                                    fit: BoxFit.fill,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 5,
                                      blurStyle: BlurStyle.outer,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Email
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(snapshot.data!.email),
                                  if (!authSnapshot.data!.emailVerified)
                                    TextButton(
                                      onPressed: () => FirebaseAuth
                                          .instance.currentUser!
                                          .sendEmailVerification(),
                                      child: const Text('verify'),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Phone
                              Text(snapshot.data!.phone.international),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Logo
                        else {
                          return TextButton(
                            onPressed: () => controller.setPage(
                                name: 'home', widget: const ClientHome()),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateColor.resolveWith(
                                (states) =>
                                    states.contains(MaterialState.hovered)
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                              ),
                              textStyle: MaterialStateTextStyle.resolveWith(
                                (states) => const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Breathing',
                                ),
                              ),
                            ),
                            child: Text(App.name),
                          );
                        }
                      },
                    )
                  }

                  // Logo
                  else ...{
                    TextButton(
                      onPressed: () => controller.setPage(
                          name: 'home', widget: const ClientHome()),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateColor.resolveWith(
                          (states) => states.contains(MaterialState.hovered)
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                        textStyle: MaterialStateTextStyle.resolveWith(
                          (states) => const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Breathing',
                          ),
                        ),
                      ),
                      child: Text(App.name),
                    ),
                  },

                  const Spacer(),
                  const Divider(),

                  // Links
                  controller.drawerLink(
                    context: context,
                    title: 'Home',
                    onTap: () => controller.setPage(
                        name: 'home', widget: const ClientHome()),
                  ),
                  controller.drawerLink(
                    context: context,
                    title: 'About Us',
                    onTap: () => controller.setPage(
                        name: 'about us', widget: const About()),
                  ),
                  controller.drawerLink(
                    context: context,
                    title: 'Our Shop',
                    onTap: () => controller.setPage(
                        name: 'our shop', widget: const Shop()),
                  ),
                  if (!authSnapshot.hasData) ...{
                    controller.drawerLink(
                      context: context,
                      title: 'Sign In',
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const Login(),
                      ),
                    )
                  },
                  if (authSnapshot.hasData) ...{
                    controller.drawerLink(
                      context: context,
                      title: 'Orders History',
                      onTap: () => controller.setPage(
                          name: 'orders', widget: const Orders()),
                    ),
                  },
                  controller.drawerLink(
                    context: context,
                    title: 'Contact Us',
                    onTap: () => controller.setPage(
                        name: 'contact us', widget: const Contact()),
                  ),

                  Spacer(flex: authSnapshot.hasData ? 2 : 3),
                  const Divider(),

                  // Social Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async => await launchUrl(
                          Uri.parse('https://wa.me/${App.phone.international}'),
                        ),
                        icon: const Icon(FontAwesomeIcons.whatsapp),
                      ),
                      IconButton(
                        onPressed: () async => await launchUrl(
                          Uri.parse('https://web.facebook.com/abu00arandas/'),
                        ),
                        icon: const Icon(FontAwesomeIcons.facebook),
                      ),
                      IconButton(
                        onPressed: () async => await launchUrl(
                          Uri.parse('https://www.instagram.com/abu_arandas/'),
                        ),
                        icon: const Icon(FontAwesomeIcons.instagram),
                      ),
                    ],
                  ),

                  // Sign Out
                  if (authSnapshot.hasData) ...{
                    controller.drawerLink(
                      context: context,
                      title: 'Sign Out',
                      onTap: () => FirebaseAuth.instance.signOut(),
                    ),
                  },
                ],
              ),
            ),
          ),

          // Body
          body: SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  constraints: const BoxConstraints(minHeight: 500),
                  child: controller.body,
                ),

                // Footer
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(32),
                  color: Colors.black,
                  child: FB5Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 500,
                      child: Column(
                        children: [
                          Image.asset('assets/images/logo.png'),
                          const SizedBox(height: 32),
                          Text(
                            App.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Ehab Arandas
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(16),
                  color: Colors.black,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Designed with love by',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () async => await launchUrl(
                          Uri.parse('https://web.facebook.com/abu00arandas/'),
                        ),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateColor.resolveWith(
                            (states) => states.contains(MaterialState.hovered)
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                        child: const Text('Ehab Arandas'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scroll to Top
          floatingActionButton: controller.scrolled
              ? FloatingActionButton(
                  onPressed: () => controller.scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: const Icon(FontAwesomeIcons.arrowUp, size: 18),
                )
              : null,
        ),
      );
}
