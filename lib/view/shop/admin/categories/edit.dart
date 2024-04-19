// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

class EditCategory extends StatefulWidget {
  final CategoryModel categoryModel;
  const EditCategory({super.key, required this.categoryModel});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController();
  XFile? pickedImage;
  late ImageProvider imageProvider;

  @override
  void initState() {
    super.initState();

    setState(() {
      name = TextEditingController(text: widget.categoryModel.name);
      imageProvider = NetworkImage(widget.categoryModel.image);
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Edit ${widget.categoryModel.name}'),
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
            onPressed: () {
              try {
                categoriesCollection.doc(widget.categoryModel.id).delete();

                FirebaseStorage.instance
                    .ref('categories')
                    .child(widget.categoryModel.id)
                    .delete();

                Navigator.pop(context);

                succesSnackBar(context, 'Deleted');
              } catch (error) {
                errorSnackBar(
                  context,
                  error.toString(),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('delete'),
          ),
          ElevatedButton(
            onPressed: () => validate(),
            child: const Text('finish'),
          ),
        ],
      );

  void validate() async {
    try {
      // Storage
      FirebaseStorage.instance
          .ref('categories')
          .child(widget.categoryModel.id)
          .putData(
            await pickedImage!.readAsBytes(),
          )

          // Image url
          .then(
            (value) => value.ref
                .getDownloadURL()

                // Firestore
                .then(
                  (value) =>
                      categoriesCollection.doc(widget.categoryModel.id).update(
                            CategoryModel(
                              id: widget.categoryModel.id,
                              name: name.text,
                              image: value,
                            ).toJson(),
                          ),
                ),
          )

          // Exit
          .then((value) {
        Navigator.pop(context);

        succesSnackBar(context, 'Updated');
      });
    } catch (error) {
      errorSnackBar(
        context,
        error.toString(),
      );
    }
  }
}
