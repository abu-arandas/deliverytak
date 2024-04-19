// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController();
  XFile? pickedImage;
  ImageProvider imageProvider = NetworkImage(noImage);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Add a new Category'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  // Image
                  Container(
                    width: double.maxFinite,
                    height: 150,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.5),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () async => await ImagePicker()
                          .pickImage(source: ImageSource.gallery)
                          .then((value) async {
                        pickedImage = value;

                        if (value != null) {
                          imageProvider = MemoryImage(
                            await value.readAsBytes(),
                          );
                        }

                        setState(() {});
                      }),
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ),

                  // Name
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    controller: name,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '* required';
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (value) => validate(),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => validate(),
            child: const Text('finish'),
          ),
        ],
      );

  void validate() async {
    if (formKey.currentState!.validate()) {
      if (pickedImage != null) {
        const chars =
            'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
        Random rnd = Random();

        String getRandomString() => String.fromCharCodes(
              Iterable.generate(
                  15,
                  (_) => chars.codeUnitAt(
                        rnd.nextInt(chars.length),
                      )),
            );

        try {
          // Storage
          FirebaseStorage.instance
              .ref('categories')
              .child(
                getRandomString(),
              )
              .putData(
                await pickedImage!.readAsBytes(),
              )

              // Image url
              .then((value) => value.ref
                  .getDownloadURL()

                  // Firestore
                  .then(
                    (value) => categoriesCollection
                        .doc(
                          getRandomString(),
                        )
                        .set(
                          CategoryModel(
                            id: '',
                            name: name.text,
                            image: value,
                          ).toJson(),
                        ),
                  ))

              // Exit
              .then((value) {
            Navigator.pop(context);

            succesSnackBar(context, 'Added');
          });
        } catch (error) {
          errorSnackBar(
            context,
            error.toString(),
          );
        }
      } else {
        errorSnackBar(context, 'Please add the Category Logo');
      }
    }
  }
}
