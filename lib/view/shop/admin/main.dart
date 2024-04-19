import '/exports.dart';

class AdminShop extends StatelessWidget {
  const AdminShop({super.key});

  @override
  Widget build(BuildContext context) => AdminScaffold(
        pageName: 'Shop',
        body: Card(
          margin: const EdgeInsets.all(16),
          child: FB5Row(
            children: [
              FB5Col(
                classNames: 'col-lg-6 col-md-6 col-sm-12 p-3',
                child: const AdminCategories(),
              ),
              FB5Col(
                classNames: 'col-lg-6 col-md-6 col-sm-12 p-3',
                child: const AdminBrands(),
              ),
              FB5Col(
                classNames: 'col-12 p-3',
                child: const AdminProducts(),
              ),
            ],
          ),
        ),
      );
}
