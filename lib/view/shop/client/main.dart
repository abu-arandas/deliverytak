import '/exports.dart';

class ClientShop extends StatelessWidget {
  const ClientShop({super.key});

  @override
  Widget build(BuildContext context) => ClientScaffold(
        pageName: 'our shop',
        pageImage:
            'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/title%2Fproducts.jpeg?alt=media&token=bd2fef08-2c10-4110-b2f6-d57003cdab69',
        drawer: MediaQuery.sizeOf(context).width < 992
            ? const ClientShopSort()
            : null,
        body: GetBuilder<SortController>(
          builder: (controller) => FB5Container(
            child: FB5Row(
              children: [
                // Sort
                if (MediaQuery.sizeOf(context).width > 992) ...{
                  FB5Col(
                    classNames: 'col-lg-3 col-md-12 col-sm-12 p-3',
                    child: const ClientShopSort(),
                  ),
                },

                // Data
                FB5Col(
                  classNames: 'col-lg-9 col-md-12 col-sm-12 p-3',
                  child: const ClientShopData(),
                ),
              ],
            ),
          ),
        ),
      );
}
