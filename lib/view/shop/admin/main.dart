import '/exports.dart';

class AdminShop extends StatelessWidget {
  const AdminShop({super.key});

  @override
  Widget build(BuildContext context) => AdminScaffold(
        pageName: 'Shop',
        body: FB5Row(
          children: [
            FB5Col(
              classNames: 'col-lg-6 col-md-6 col-sm-12 p-3',
              child: const Card(
                margin: EdgeInsets.all(8),
                child: AdminCategories(),
              ),
            ),
            FB5Col(
              classNames: 'col-lg-6 col-md-6 col-sm-12 p-3',
              child: const Card(
                margin: EdgeInsets.all(8),
                child: AdminBrands(),
              ),
            ),
            FB5Col(
              classNames: 'col-12 p-3',
              child: const Card(
                margin: EdgeInsets.all(8),
                child: AdminProducts(),
              ),
            ),
          ],
        ),
      );
}
