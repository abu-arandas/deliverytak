import '/exports.dart';

class SingleOrderDeleteButton extends StatelessWidget {
  final OrderModel order;
  const SingleOrderDeleteButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: singleUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool show;

            bool progress() {
              switch (order.progress) {
                case OrderProgress.binding:
                  return show = true;
                case OrderProgress.inProgress:
                  return show = true;
                case OrderProgress.done:
                  return show = false;
                case OrderProgress.deleted:
                  return show = false;
              }
            }

            bool role() {
              switch (snapshot.data!.role) {
                case UserRole.admin:
                  return show = true;
                case UserRole.client:
                  return show = true;
                case UserRole.driver:
                  return show = false;
              }
            }

            show = progress() && role();

            if (show) {
              return ElevatedButton(
                onPressed: () => deleteOrder(
                  context: context,
                  id: order.id,
                  clientId: order.clientId,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Delete'),
              );
            } else {
              return Container();
            }
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
