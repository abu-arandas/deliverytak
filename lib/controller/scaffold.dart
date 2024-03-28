import '/exports.dart';

class ScaffoldController extends GetxController {
  static ScaffoldController instance = Get.find();

  String pageName = 'home';
  Widget body = const ClientHome();
  Drawer? drawer;

  void setPage({required String name, required Widget widget, Drawer? drawer}) {
    scaffoldKey.currentState!.closeEndDrawer();
    pageName = name;
    body = widget;
    drawer = this.drawer;
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );
    update();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  bool scrolled = false;

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
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      scrolled = scrollController.offset >= 10;
      update();
    });
  }
}
