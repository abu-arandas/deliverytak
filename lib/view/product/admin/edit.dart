import '/exports.dart';

class EditProduct extends StatelessWidget {
  final String id;
  const EditProduct({super.key, required this.id});

  @override
  Widget build(BuildContext context) => AdminScaffold(
        pageName: 'Shop',
        body: Container(),
      );
}
