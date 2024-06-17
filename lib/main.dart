import 'exports.dart';

/*
flutter run -d edge --web-renderer html // to run the app
flutter build web --web-renderer html --release // to generate a production build
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Montserrat',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3A57E8),
              surface: const Color(0xFFF8F8F8),
              brightness: Brightness.light,
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.all(16),
              labelStyle: const TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            buttonTheme: const ButtonThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              buttonColor: Color(0xFF3A57E8),
            ),
            textButtonTheme: const TextButtonThemeData(
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.focused) ||
                          states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)
                      ? Colors.white
                      : const Color(0xFF3A57E8),
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.focused) ||
                          states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)
                      ? const Color(0xFF3A57E8)
                      : Colors.white,
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.focused) ||
                          states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)
                      ? const Color(0xFF3A57E8)
                      : Colors.transparent,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.focused) ||
                          states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)
                      ? Colors.white
                      : const Color(0xFF3A57E8),
                ),
                side: WidgetStateProperty.resolveWith(
                  (states) => BorderSide(
                    color: states.contains(WidgetState.focused) ||
                            states.contains(WidgetState.hovered) ||
                            states.contains(WidgetState.pressed)
                        ? Colors.white
                        : const Color(0xFF3A57E8),
                  ),
                ),
              ),
            ),
            cardTheme: const CardTheme(elevation: 2.5),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              shape: CircleBorder(),
              backgroundColor: Color(0xFF3A57E8),
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: ThemeMode.light,
          initialBinding: BindingsBuilder(() {
            Get.put(NotificationController());
            Get.put(SortController());
            Get.put(LocationController());
            Get.put(CartController());
          }),
          home: OrientationBuilder(
            builder: (context, orientation) => const Main(),
          ),
        ),
      );
}
