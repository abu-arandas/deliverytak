import '/exports.dart';

class ClientBody extends StatelessWidget {
  final String pageName;
  final String? pageImage;
  final Widget body;
  final ScrollController scrollController;

  const ClientBody({
    super.key,
    required this.pageName,
    this.pageImage,
    required this.body,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            if (pageImage != null && pageImage != '') ...{
              CachedNetworkImage(
                imageUrl: pageImage!,
                imageBuilder: (context, imageProvider) => Container(
                  width: double.maxFinite,
                  height: 300,
                  padding: const EdgeInsets.all(64),
                  margin: const EdgeInsets.only(bottom: 32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                          Colors.black26, BlendMode.darken),
                    ),
                  ),
                  child: Text(
                    toTitleCase(pageName),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            },

            // Body
            body,

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
                      App.logo(),
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
                      foregroundColor: WidgetStateColor.resolveWith(
                        (states) => states.contains(WidgetState.hovered)
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
      );
}
