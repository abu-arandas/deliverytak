import '/exports.dart';

class ClientHome extends StatelessWidget {
  const ClientHome({super.key});

  @override
  Widget build(BuildContext context) => ClientScaffold(
        pageName: 'home',
        body: Column(
          children: [
            const ClientHero(),
            SizedBox(height: MediaQuery.sizeOf(context).width > 767 ? 64 : 32),
            const ClientBrands(),
            const ClientProducts(),
            SizedBox(height: MediaQuery.sizeOf(context).width > 767 ? 64 : 32),
            const ClientSpecialOffer(),
            SizedBox(height: MediaQuery.sizeOf(context).width > 767 ? 64 : 32),
          ],
        ),
      );
}
