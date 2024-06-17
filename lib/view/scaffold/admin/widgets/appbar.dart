import '/exports.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBar({super.key});

  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.surface,
        child: FB5Container(
          child: Row(
            children: [
              const DrawerButton(),
              RichText(
                text: TextSpan(
                  text: 'Good ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: DateTime.now().day >= 12 ? 'Afternoon' : 'Morning',
                    ),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: DateFormat.yMMMEd().format(
                        DateTime.now(),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      );

  @override
  Size get preferredSize => const Size(double.maxFinite, 75);
}
