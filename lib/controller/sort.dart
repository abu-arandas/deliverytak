import '/exports.dart';

class SortController extends GetxController {
  static SortController instance = Get.find();

  TextEditingController title = TextEditingController();
  String? brand, category;
  Genders? gender;

  Stream<List<ProductModel>> limitProducts() =>
      productsCollection.snapshots().map((query) =>
          query.docs.map((item) => ProductModel.fromDoc(item)).where((element) {
            // Title
            if (title.text.isNotEmpty) {
              return element.name
                  .toLowerCase()
                  .contains(title.text.toLowerCase());
            }

            // Brand
            if (brand != null && element.brand != null) {
              return element.brand!.toLowerCase() == brand;
            }

            // Category
            if (category != null) {
              return element.category!.toLowerCase() == category;
            }

            // Brand
            if (gender != null) {
              return element.gender == gender;
            }

            return true;
          }).toList());
}

enum Genders { men, women, kids }

EnumValues<Genders> genders = EnumValues({
  'Men': Genders.men,
  'Women': Genders.women,
  'Kids': Genders.kids,
});
