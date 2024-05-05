import '/exports.dart';

class AdminUsersSection extends StatelessWidget {
  final List<UserModel> drivers;
  const AdminUsersSection({super.key, required this.drivers});

  @override
  Widget build(BuildContext context) {
    List<Map> data = drivers
        .map((driver) => {
              'driver': driver,
              'distance': Geolocator.distanceBetween(
                driver.address!.latitude,
                driver.address!.longitude,
                App.address.latitude,
                App.address.longitude,
              ),
            })
        .toList();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Drivers',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length > 3 ? 3 : data.length,
            itemBuilder: (context, index) {
              UserModel user = data[index]['driver'];

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12.5),
                    child: CachedNetworkImage(
                      imageUrl: user.image,
                      fit: BoxFit.fill,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  title: Text('${user.name['first']} ${user.name['last']}'),
                  trailing: Text(data[index]['distance'].toString()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
