import '/exports.dart';

CollectionReference<Map<String, dynamic>> favoritesCollection =
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites');

Widget favoriteButton({required String id}) => StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: favoritesCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> products =
                    snapshot.data!.docs.map((element) => element.id).toList();

                bool exists = products.contains(id);

                return OutlinedButton(
                  onPressed: () {
                    if (exists) {
                      favoritesCollection.doc(id).delete();
                    } else {
                      favoritesCollection.doc(id).set({});
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    fixedSize: const Size(50, 50),
                    foregroundColor: exists
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                      color: exists
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Icon(
                    exists ? Icons.favorite : Icons.favorite_border,
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
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container();
        }
      },
    );
