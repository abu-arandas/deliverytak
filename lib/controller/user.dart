// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

CollectionReference<Map<String, dynamic>> usersCollection =
    FirebaseFirestore.instance.collection('users');

Stream<List<UserModel>> users() => usersCollection.snapshots().map(
    (query) => query.docs.map((item) => UserModel.fromJson(item)).toList());
Stream<List<UserModel>> drivers() =>
    usersCollection.snapshots().map((query) => query.docs
        .map((item) => UserModel.fromJson(item))
        .where((element) => element.role == UserRole.driver)
        .toList());
Stream<UserModel> singleUser(id) => usersCollection
    .doc(id)
    .snapshots()
    .map((query) => UserModel.fromJson(query));

void signIn({
  required BuildContext context,
  required String email,
  required String password,
}) {
  try {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => page(context: context, page: const Main()));
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void updatePassword({
  required BuildContext context,
  required String password,
}) {
  try {
    FirebaseAuth.instance.currentUser!
        .updatePassword(password)
        .then((value) => page(context: context, page: const Main()));
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void updateProfile({
  required BuildContext context,
  required String first,
  String? last,
  required PhoneNumber phone,
  XFile? pickedImage,
  required String image,
}) async {
  try {
    String id = FirebaseAuth.instance.currentUser!.uid;

    String? imageUrl;

    if (pickedImage != null) {
      await FirebaseStorage.instance
          .ref('users/')
          .child(id)
          .putFile(File(pickedImage.path));

      imageUrl = await FirebaseStorage.instance
          .ref('users/')
          .child(id)
          .getDownloadURL();
    }

    await usersCollection.doc(id).update({
      'name': {'first': first, 'last': last ?? ''},
      'phone': phone.toJson(),
      'image': imageUrl ?? image,
    });

    page(context: context, page: const Main());
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void newDriver({
  required BuildContext context,
  required String email,
  required String password,
  required PhoneNumber phone,
}) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(UserModel(
          id: FirebaseAuth.instance.currentUser!.uid,
          name: {'first': 'Driver', 'last': ''},
          email: email,
          image: noImage,
          phone: phone,
          role: UserRole.driver,
          token: '',
        ).toJson());

    await FirebaseAuth.instance.signOut();

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'admin@deliverytak.com',
      password: '123456',
    );

    page(context: context, page: const Main());
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void updateToken({required BuildContext context}) {
  try {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        usersCollection.doc(event.uid).update({
          'token': await FirebaseMessaging.instance.getToken(),
        });
      }
    });
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void currentUser({
  required BuildContext context,
  required String email,
  required String password,
  required Map name,
  required PhoneNumber phone,
}) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String id = FirebaseAuth.instance.currentUser!.uid;

    await usersCollection.doc(id).set(UserModel(
          id: id,
          name: name,
          email: email,
          image: noImage,
          phone: phone,
          role: UserRole.client,
          token: '',
        ).toJson());

    page(context: context, page: const Main());
    succesSnackBar(context, 'Welcome to our app');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void sendPasswordResetEmail(
    {required BuildContext context, required String email}) {
  try {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => page(context: context, page: const Main()));
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void signOut({required BuildContext context}) {
  try {
    FirebaseAuth.instance.signOut();

    page(context: context, page: const Main());
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}
