import '/exports.dart';

class ClientScaffold extends StatefulWidget {
  final String pageName;
  final String? pageImage;
  final Widget body;
  final Widget? drawer;

  const ClientScaffold({
    super.key,
    required this.pageName,
    this.pageImage,
    required this.body,
    this.drawer,
  });

  @override
  State<ClientScaffold> createState() => _ClientScaffoldState();
}

class _ClientScaffoldState extends State<ClientScaffold> {

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
          extendBodyBehindAppBar: widget.pageImage == null,

          // Nav Bar
          appBar: ClientAppBar(
            pageName: widget.pageName,
            scrolled: scrolled,
            hasDrawer: widget.drawer != null,
          ),

          // Menu
          endDrawer: ClientDrawer(pageName: widget.pageName),

          // Drawer
          drawer: widget.drawer != null
              ? Drawer(
                  shape: const BeveledRectangleBorder(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Sort Products',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        const SizedBox(height: 16),
                        widget.drawer!,
                      ],
                    ),
                  ),
                )
              : null,

          // Body
          body: ClientBody(
            pageName: widget.pageName,
            pageImage: widget.pageImage,
            body: widget.body,
            scrollController: scrollController,
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
