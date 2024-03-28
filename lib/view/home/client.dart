import '/exports.dart';

class ClientHome extends StatelessWidget {
  const ClientHome({super.key});

  FB5Col hero({
    required BuildContext context,
    required String classNames,
    required List<Widget> children,
  }) =>
      FB5Col(
        classNames: '$classNames p-5',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      );

  Widget tile(
          {required String image, required String title, bool first = false}) =>
      Container(
        width: double.maxFinite,
        height: 200 * (first ? 2 : 1),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.transparent.withOpacity(0.5), BlendMode.darken),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Hero
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/hero.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.25),
                  BlendMode.darken,
                ),
              ),
            ),
            child: FB5Container(
              child: FB5Row(
                classNames: 'p-2',
                children: [
                  hero(
                    context: context,
                    classNames: 'col-12',
                    children: [
                      const Text(
                        'MEN CAMPAIGN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'The Trends of The\nSeason',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Breathing',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  hero(
                    context: context,
                    classNames: 'col-lg-7 col-md-7 col-sm-12',
                    children: [
                      const Text(
                        'Shoes collection',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'The Iconic Y-3 Qasa from the japanese designer Yohji Yamamoto are now available in the triple white colorway.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  hero(
                    context: context,
                    classNames: 'col-lg-5 col-md-5 col-sm-12',
                    children: [
                      const Text(
                        'Clothes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Exclusive offers are available until\nJune 21. Some restrictions may apply.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // About
          About.about(),

          // Most Selling
          Container(
            width: double.maxFinite,
            color: Colors.transparent.withOpacity(0.1),
            child: const MostSelling(),
          ),

          // Collections
          FB5Row(
            children: [
              FB5Col(
                classNames: 'col-lg-6 col-md-6 col-sm-12',
                child: tile(
                  first: true,
                  image: 'assets/images/collections/1.jpg',
                  title: 'New Arrivals',
                ),
              ),
              FB5Col(
                classNames: 'col-lg-6 col-md-6 col-sm-12',
                child: Column(
                  children: [
                    FB5Row(
                      children: [
                        FB5Col(
                          classNames: 'col-lg-6 col-md-6 col-sm-12',
                          child: tile(
                            image: 'assets/images/collections/2.jpg',
                            title: 'Women Collections',
                          ),
                        ),
                        FB5Col(
                          classNames: 'col-lg-6 col-md-6 col-sm-12',
                          child: tile(
                            image: 'assets/images/collections/3.jpg',
                            title: 'Men Collections',
                          ),
                        ),
                        FB5Col(
                          classNames: 'col-12',
                          child: tile(
                            image: 'assets/images/collections/4.jpg',
                            title: 'Backpack For Women',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Contact Us
          Contact.contact(context),
        ],
      );
}
