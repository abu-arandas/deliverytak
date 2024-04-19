import '/exports.dart';

class SortController extends GetxController {
  static SortController instance = Get.find();

  TextEditingController title = TextEditingController();
  BrandModel? brandModel;
  CategoryModel? categoryModel;
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
            if (brandModel != null && element.brand != null) {
              return element.brand!.toLowerCase() == brandModel!.id;
            }

            // Category
            if (categoryModel != null) {
              return element.category.toLowerCase() == categoryModel!.name;
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
