import '/exports.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();

  CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<List<UserModel>> users() => usersCollection.snapshots().map(
      (query) => query.docs.map((item) => UserModel.fromJson(item)).toList());

  Stream<UserModel> singletUser(id) => usersCollection
      .doc(id)
      .snapshots()
      .map((query) => UserModel.fromJson(query));
}
