import '/exports.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.hasData) {
            return StreamBuilder(
              stream:
                  UserController.instance.singletUser(authSnapshot.data!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  switch (userSnapshot.data!.role) {
                    case UserRole.admin:
                      return const AdminHome();
                    case UserRole.client:
                      return const ClientScaffold();
                  }
                } else if (userSnapshot.hasError) {
                  return Scaffold(
                    body: Center(child: Text(userSnapshot.error.toString())),
                  );
                } else {
                  return const ClientScaffold();
                }
              },
            );
          } else if (authSnapshot.hasError) {
            return Scaffold(
              body: Center(child: Text(authSnapshot.error.toString())),
            );
          } else {
            return const ClientScaffold();
          }
        },
      );
}
