import '/exports.dart';

class AdminScaffold extends StatefulWidget {
  final String pageName;
  final Widget body;

  const AdminScaffold({
    super.key,
    required this.pageName,
    required this.body,
  });

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

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
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          key: scaffoldKey,

          // Nav Bar
          appBar: AdminAppBar(scaffoldKey: scaffoldKey),

          // Side
          drawer: Drawer(
            shape: const BeveledRectangleBorder(),
            child: AdminSideSection(
              pageName: widget.pageName,
            ),
          ),

          // Search
          endDrawer: const Drawer(
            shape: BeveledRectangleBorder(),
            child: AdminSearch(),
          ),

          // Body
          body: SingleChildScrollView(
            controller: scrollController,
            child: widget.body,
          ),

          // Scroll to Top
          floatingActionButton: scrolled
              ? FloatingActionButton(
                  onPressed: () => scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: const Icon(Icons.keyboard_arrow_up),
                )
              : null,
        ),
      );
}
