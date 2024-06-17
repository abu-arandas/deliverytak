import '/exports.dart';

class ClientHero extends StatelessWidget {
  const ClientHero({super.key});

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/deliverytak.appspot.com/o/hero.jpg?alt=media&token=e6597e1d-1d78-4da4-ae8e-31759e3de40c',
        errorWidget: (context, url, error) => Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
          child: content(context),
        ),
        imageBuilder: (context, imageProvider) => Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
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
      );

  Widget content(BuildContext context) => FB5Container(
        child: FB5Row(
          classNames: 'p-5',
          children: [
            FB5Col(
              classNames: 'col-lg-6 col-md-9 col-sm-12',
              child: Text(
                'Raining Offers For Hot Summer!',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
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
              classNames: 'col-lg-6 col-md-9 col-sm-12 px-1 py-3',
              child: Text(
                '25% Off On All Products',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            FB5Col(classNames: 'col-12', child: Container()),
            FB5Col(
              classNames: 'p-1',
              child: ElevatedButton(
                onPressed: () => page(
                  context: context,
                  page: const ClientShop(),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.hovered) ||
                            states.contains(WidgetState.focused) ||
                            states.contains(WidgetState.pressed)
                        ? Colors.black
                        : Colors.white,
                  ),
                  foregroundColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.hovered) ||
                            states.contains(WidgetState.focused) ||
                            states.contains(WidgetState.pressed)
                        ? Colors.white
                        : Colors.black,
                  ),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                ),
                child: const Text('Shop Now'),
              ),
            )
          ],
        ),
      );
}
