// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

CollectionReference<Map<String, dynamic>> categoriesCollection =
    FirebaseFirestore.instance.collection('categories');

Stream<List<CategoryModel>> categories() =>
    categoriesCollection.snapshots().map((query) =>
        query.docs.map((item) => CategoryModel.fromDoc(item)).toList());
Stream<CategoryModel> singleCategory(id) => categoriesCollection
    .doc(id)
    .snapshots()
    .map((query) => CategoryModel.fromDoc(query));

void addCategory({
  required BuildContext context,
  required String name,
  XFile? pickedImage,
}) async {
  try {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    CategoryModel categoryModel = CategoryModel(
      id: String.fromCharCodes(Iterable.generate(
        15,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      )),
      name: name,
      image: noImage,
    );

    await categoriesCollection.doc().set(categoryModel.toJson());

    if (pickedImage != null) {
      await FirebaseStorage.instance
          .ref('categories')
          .child(categoryModel.id)
          .putData(await pickedImage.readAsBytes());
      await FirebaseStorage.instance
          .ref('categories')
          .child(categoryModel.id)
          .getDownloadURL()
          .then((value) => categoriesCollection
              .doc(categoryModel.id)
              .update({'image': value}));
    }

    Navigator.pop(context);
    succesSnackBar(context, 'Added');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void updateCategory({
  required BuildContext context,
  required String id,
  required String name,
  XFile? pickedImage,
}) async {
  try {
    categoriesCollection.doc(id).update({'name': name});

    if (pickedImage != null) {
      await FirebaseStorage.instance
          .ref('categories')
          .child(id)
          .putData(await pickedImage.readAsBytes());
      await FirebaseStorage.instance
          .ref('categories')
          .child(id)
          .getDownloadURL()
          .then(
              (value) => categoriesCollection.doc(id).update({'image': value}));
    }

    Navigator.pop(context);
    succesSnackBar(context, 'Updated');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void deleteCategory({required BuildContext context, required String id}) async {
  try {
    await categoriesCollection.doc(id).delete();
    await FirebaseStorage.instance.ref('categories/$id/').delete();

    Navigator.pop(context);
    succesSnackBar(context, 'Deleted');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}
