import '/exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => FlutterBootstrap5(
        builder: (context) => GetMaterialApp(
          title: App.name,
          debugShowCheckedModeBanner: false,
          theme: BootstrapTheme.of(context).toTheme(
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Montserrat',
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF540804)),
              iconTheme: const IconThemeData(size: 20),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.all(16),
                labelStyle: const TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.5)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.5)),
              ),
              buttonTheme: const ButtonThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              textButtonTheme: const TextButtonThemeData(
                style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.pressed)
                        ? Colors.white
                        : const Color(0xFF540804),
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith(
                    (states) => states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.pressed)
                        ? const Color(0xFF540804)
                        : Colors.white,
                  ),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                    (states) => states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.pressed)
                        ? Colors.white
                        : const Color(0xFF540804),
                  ),
                  side: MaterialStateProperty.resolveWith(
                    (states) => BorderSide(
                      color: states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.hovered) ||
                              states.contains(MaterialState.pressed)
                          ? Colors.white
                          : const Color(0xFF540804),
                    ),
                  ),
                ),
              ),
              cardTheme: const CardTheme(elevation: 2.5),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                shape: CircleBorder(),
                backgroundColor: Color(0xFF540804),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          initialBinding: BindingsBuilder(() {
            Get.put(UserController());
            Get.put(ScaffoldController());
            Get.put(ProductController());
            Get.put(OrderController());
            Get.put(LocationController());
          }),
          home: OrientationBuilder(
            builder: (context, orientation) => const Home(),
          ),
        ),
      );
}
