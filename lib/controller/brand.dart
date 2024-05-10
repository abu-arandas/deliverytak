// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

CollectionReference<Map<String, dynamic>> brandsCollection =
    FirebaseFirestore.instance.collection('brands');

Stream<List<BrandModel>> brands() => brandsCollection.snapshots().map(
      (query) => query.docs.map((item) => BrandModel.fromDoc(item)).toList(),
    );
Stream<BrandModel> singleBrand(id) => brandsCollection
    .doc(id)
    .snapshots()
    .map((query) => BrandModel.fromDoc(query));

void addBrand({
  required BuildContext context,
  required String name,
  XFile? pickedImage,
}) async {
  try {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    BrandModel brandModel = BrandModel(
      id: String.fromCharCodes(Iterable.generate(
        15,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      )),
      name: name,
      image: noImage,
    );

    await brandsCollection.doc().set(brandModel.toJson());

    if (pickedImage != null) {
      await FirebaseStorage.instance
          .ref('brands')
          .child(brandModel.id)
          .putData(await pickedImage.readAsBytes());
      await FirebaseStorage.instance
          .ref('brands')
          .child(brandModel.id)
          .getDownloadURL()
          .then((value) =>
              brandsCollection.doc(brandModel.id).update({'image': value}));
    }

    Navigator.pop(context);
    succesSnackBar(context, 'Added');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void updateBrand({
  required BuildContext context,
  required String id,
  required String name,
  XFile? pickedImage,
}) async {
  try {
    brandsCollection.doc(id).update({'name': name});

    if (pickedImage != null) {
      await FirebaseStorage.instance
          .ref('brands')
          .child(id)
          .putData(await pickedImage.readAsBytes());
      await FirebaseStorage.instance
          .ref('brands')
          .child(id)
          .getDownloadURL()
          .then((value) => brandsCollection.doc(id).update({'image': value}));
    }

    Navigator.pop(context);
    succesSnackBar(context, 'Updated');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}

void deleteBrand({required BuildContext context, required String id}) async {
  try {
    await brandsCollection.doc(id).delete();
    await FirebaseStorage.instance.ref('brands/$id/').delete();

    Navigator.pop(context);
    succesSnackBar(context, 'Deleted');
  } on FirebaseException catch (error) {
    errorSnackBar(context, error.message.toString());
  }
}
