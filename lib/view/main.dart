import '/exports.dart';

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.hasData) {
            return StreamBuilder(
              stream: singleUser(authSnapshot.data!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  tokens(userSnapshot.data!.id);

                  switch (userSnapshot.data!.role) {
                    case UserRole.admin:
                      return const AdminHome();
                    case UserRole.client:
                      return const ClientHome();
                    case UserRole.driver:
                      return const DriverHome();
                  }
                }

                return const ClientHome();
              },
            );
          }

          return const ClientHome();
        },
      );

  void tokens(id) async => usersCollection.doc(id).update({
        'token': await FirebaseMessaging.instance.getToken(),
      });
}
