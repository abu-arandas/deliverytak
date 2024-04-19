import '/exports.dart';

class ClientDrawer extends StatelessWidget {
  final String pageName;
  const ClientDrawer({super.key, required this.pageName});

  drawerLink({
    required BuildContext context,
    required String title,
    required void Function()? onTap,
  }) =>
      ListTile(
        onTap: onTap,
        selected: pageName.toLowerCase() == title.toLowerCase(),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Drawer(
        shape: const BeveledRectangleBorder(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // User Data
              if (authSnapshot.hasData) ...{
                StreamBuilder(
                  stream: singletUser(authSnapshot.data!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          // Edit
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton.outlined(
                              onPressed: () => authSnapshot.hasData
                                  ? showDialog(
                                      context: context,
                                      builder: (context) =>
                                          Profile(id: authSnapshot.data!.uid),
                                    )
                                  : page(
                                      context: context,
                                      page: const Login(),
                                    ),
                              icon: const Icon(Icons.edit),
                            ),
                          ),

                          // Image
                          CachedNetworkImage(
                            imageUrl: snapshot.data!.image,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
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
                      return Center(
                          child: Text(
                        snapshot.error.toString(),
                      ));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Logo
                    else {
                      return TextButton(
                        onPressed: () => page(
                          context: context,
                          page: const Main(),
                        ),
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
                      );
                    }
                  },
                )
              }

              // Logo
              else ...{
                TextButton(
                  onPressed: () => page(
                    context: context,
                    page: const Main(),
                  ),
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
              const SizedBox(height: 16),
              const Divider(),

              // Links
              drawerLink(
                context: context,
                title: 'Home',
                onTap: () => page(
                  context: context,
                  page: const Main(),
                ),
              ),
              drawerLink(
                context: context,
                title: 'About Us',
                onTap: () => page(
                  context: context,
                  page: const About(),
                ),
              ),
              drawerLink(
                context: context,
                title: 'Our Shop',
                onTap: () => page(
                  context: context,
                  page: const ClientShop(),
                ),
              ),
              if (!authSnapshot.hasData) ...{
                drawerLink(
                  context: context,
                  title: 'Sign In',
                  onTap: () => page(
                    context: context,
                    page: const Login(),
                  ),
                )
              },
              if (authSnapshot.hasData) ...{
                drawerLink(
                  context: context,
                  title: 'Orders History',
                  onTap: () => page(
                    context: context,
                    page: const ClientScaffold(
                      pageName: 'Orders',
                      pageImage:
                          'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/title%2Forders.jpeg?alt=media&token=0c23f49a-e5eb-44fb-91db-0e8613fc16aa',
                      body: Orders(),
                    ),
                  ),
                ),
              },
              drawerLink(
                context: context,
                title: 'Contact Us',
                onTap: () => page(
                  context: context,
                  page: const Contact(),
                ),
              ),

              const Spacer(),

              // Sign Out
              if (authSnapshot.hasData) ...{
                drawerLink(
                  context: context,
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
              },

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
            ],
          ),
        ),
      );
}
