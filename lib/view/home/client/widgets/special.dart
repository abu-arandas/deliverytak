import '/exports.dart';

class ClientSpecialOffer extends StatelessWidget {
  const ClientSpecialOffer({super.key});

  @override
  Widget build(BuildContext context) => FB5Container(
        child: CachedNetworkImage(
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/special-offer.jpg?alt=media&token=1448e344-796c-4b17-bb40-4c4e0619f500',
          errorWidget: (context, url, error) => Container(
            width: double.maxFinite,
            height: 500,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
            child: content(context),
          ),
          imageBuilder: (context, imageProvider) => Container(
            width: double.maxFinite,
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.25),
                  BlendMode.darken,
                ),
              ),
            ),
            child: content(context),
          ),
        ),
      );

  Widget content(BuildContext context) => FB5Row(
        classNames: 'p-5',
        children: [
          FB5Col(
            classNames: 'col-lg-6 col-md-9 col-sm-12',
            child: Text(
              'Limited Time Offer',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          FB5Col(
            classNames: 'col-12',
            child: Container(),
          ),
          FB5Col(
            classNames: 'col-lg-6 col-md-9 col-sm-12 px-1 py-3',
            child: Text(
              'Special Edition',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ),
          FB5Col(
            classNames: 'col-12',
            child: Container(),
          ),
          FB5Col(
            classNames: 'col-lg-6 col-md-9 col-sm-12',
            child: const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut elit tellus, luctus nec ullamcorper mattis, pulvinar dapibus leo.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
}
