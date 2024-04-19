import '/exports.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) => ClientScaffold(
        pageName: 'about us',
        pageImage:
            'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/title%2Fabout.jpg?alt=media&token=645b847a-306a-47db-a17e-20b8cd63d0be',
        body: FB5Container(
          child: FB5Row(
            classNames: 'p-3',
            children: [
              // Image
              FB5Col(
                classNames: 'col-lg-6 col-md-6 col-sm-12',
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/about-banner.jpg?alt=media&token=cf4376a1-edb8-4f00-b586-f495cdf080df',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                ),
              ),

              // Info
              FB5Col(
                classNames: 'col-lg-6 col-md-6 col-sm-12 p-2',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Who We are',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(App.description),
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: const [
                        ListTile(
                          leading: Text(
                            '\u2022',
                            style: TextStyle(fontSize: 30),
                          ),
                          title: Text(
                            'We are not just for fashion',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            '\u2022',
                            style: TextStyle(fontSize: 30),
                          ),
                          title: Text(
                            'We are a 100% urban wear brand, built by several hands over the last 20 years.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
