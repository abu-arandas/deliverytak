import '/exports.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const AdminAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) => FB5Container(
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
              onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
      );

  @override
  Size get preferredSize => const Size(double.maxFinite, 75);
}
