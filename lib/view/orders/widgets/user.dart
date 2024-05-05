import '/exports.dart';

class SingleOrderUser extends StatelessWidget {
  final String userId;
  const SingleOrderUser({super.key, required this.userId});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: singleUser(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String title = roles.reverse[snapshot.data!.role]!;

            return Container(
              width: 500,
              margin: const EdgeInsets.all(16).copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    onTap: () async => await launchUrl(
                      Uri.parse('tel:${snapshot.data!.phone.international}'),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data!.image,
                        fit: BoxFit.fill,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(
                      '${snapshot.data!.name['first']} ${snapshot.data!.name['last']}',
                    ),
                    subtitle: Text(snapshot.data!.phone.international),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      );
}
