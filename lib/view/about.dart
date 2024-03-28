import '/exports.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) => FB5Row(
        children: [
          // Title
          FB5Col(
            classNames: 'col-12',
            child: pageTtitle(
              context: context,
              text: 'About Us',
              bg: 'assets/images/title/about.jpg',
            ),
          ),

          // About
          FB5Col(
            classNames: 'col-12',
            child: about(),
          ),
        ],
      );

  static Widget about() => FB5Container(
        child: FB5Row(
          classNames: 'p-3',
          children: [
            // Image
            FB5Col(
              classNames: 'col-lg-6 col-md-6 col-sm-12',
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: Image.asset(
                  'assets/images/about-banner.jpg',
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
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(App.description),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: const [
                      ListTile(
                        leading: Text('\u2022', style: TextStyle(fontSize: 30)),
                        title: Text(
                          'We are not just for fashion',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      ListTile(
                        leading: Text('\u2022', style: TextStyle(fontSize: 30)),
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
      );
}
