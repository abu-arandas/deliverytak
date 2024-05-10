import '/exports.dart';

class EditBrand extends StatefulWidget {
  final BrandModel brandModel;
  const EditBrand({super.key, required this.brandModel});

  @override
  State<EditBrand> createState() => _EditBrandState();
}

class _EditBrandState extends State<EditBrand> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController();
  XFile? pickedImage;
  late ImageProvider imageProvider;

  @override
  void initState() {
    super.initState();

    setState(() {
      name = TextEditingController(text: widget.brandModel.name);
      imageProvider = NetworkImage(widget.brandModel.image);
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Edit ${widget.brandModel.name}'),
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
            onPressed: () => deleteBrand(
              context: context,
              id: widget.brandModel.id,
            ),
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
    if (formKey.currentState!.validate()) {
      updateBrand(
        context: context,
        id: widget.brandModel.id,
        name: name.text,
        pickedImage: pickedImage,
      );
    }
  }
}
