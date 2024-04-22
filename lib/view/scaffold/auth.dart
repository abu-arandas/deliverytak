import '/exports.dart';

class AuthScaffold extends StatelessWidget {
  final String title, subTitle;
  final Form form;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.subTitle,
    required this.form,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FB5Row(
          children: [
            // Image
            if (MediaQuery.sizeOf(context).width >= 767) ...{
              FB5Col(
                classNames: 'col-lg-6 col-md-4 col-sm-12',
                child: CachedNetworkImage(
                  imageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/authentication.jpg?alt=media&token=2cf2a321-fc6b-4ffb-b6de-1393b998782a',
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: MediaQuery.sizeOf(context).height,
                ),
              )
            },

            // Form
            FB5Col(
              classNames: 'col-lg-6 col-md-8 col-sm-12 px-3',
              child: Container(
                width: double.maxFinite,
                height: MediaQuery.sizeOf(context).height,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Title
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            App.logo(color: Colors.black),
                            const SizedBox(height: 16),
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(subTitle, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Form
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: form,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
