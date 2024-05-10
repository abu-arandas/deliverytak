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
            bool titleSort;

            if (title.text.isNotEmpty) {
              titleSort =
                  element.name.toLowerCase().contains(title.text.toLowerCase());
            } else {
              titleSort = true;
            }

            // Brand
            bool brandSort;
            if (brand != null) {
              brandSort = element.brand == brand;
            } else {
              brandSort = true;
            }

            // Category
            bool categorySort;
            if (category != null) {
              categorySort = element.category == category;
            } else {
              categorySort = true;
            }

            // Brand
            bool genderSort;
            if (gender != null && element.gender != null) {
              genderSort = element.gender == gender;
            } else {
              genderSort = true;
            }

            return titleSort && brandSort && categorySort && genderSort;
          }).toList());
}

enum Genders { men, women, kids }

EnumValues<Genders> genders = EnumValues({
  'Men': Genders.men,
  'Women': Genders.women,
  'Kids': Genders.kids,
});
