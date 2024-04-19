import '/exports.dart';

class AdminUsersSection extends StatelessWidget {
  final List<OrderModel> orders;
  final List<UserModel> clients;

  const AdminUsersSection({
    super.key,
    required this.orders,
    required this.clients,
  });

  @override
  Widget build(BuildContext context) {
    List<Map> ids = [];

    /*for (var order in orders) {
      if (ids.any((element) => element['client'] == order.clientId),) {
        ids.any((element) => element['count']++);
      } else {
        ids.add({'client': order.clientId, 'count': 1});
      }
    }*/

    ids.sort(
      (a, b) => a['count'].compareTo(b['count']),
    );

    return Card(
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ids.length > 3 ? 3 : ids.length,
        itemBuilder: (context, index) {
          UserModel user = clients
              .singleWhere((element) => element.id == ids[index]['client']);

          return ListTile(
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
            trailing: Text(
              ids[index]['count'].toString(),
            ),
          );
        },
      ),
    );
  }
}
