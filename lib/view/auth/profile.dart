// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

class Profile extends StatefulWidget {
  final String id;
  const Profile({super.key, required this.id});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<FormState> formKey = GlobalKey();
  XFile? pickedImage;
  ImageProvider? image;

  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  PhoneController phone = PhoneController();

  bool loading = false;

  late UserModel user;

  @override
  void initState() {
    super.initState();

    usersCollection.doc(widget.id).get().then((value) {
      user = UserModel.fromJson(value);

      image = NetworkImage(user.image);
      fName = TextEditingController(text: user.name['first']);
      lName = TextEditingController(text: user.name['last']);
      phone = PhoneController(initialValue: user.phone);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
      // Title
      title: const Text('Enter your informations to Complete'),

      // Form
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 125,
                    height: 125,
                    margin: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image: image!,
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                          Colors.transparent.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () async {
                        if (pickedImage == null) {
                          await ImagePicker()
                              .pickImage(source: ImageSource.gallery)
                              .then((value) async {
                            pickedImage = value;

                            image = MemoryImage(
                              await value!.readAsBytes(),
                            );

                            setState(() {});
                          });
                        } else {
                          setState(() => pickedImage = null);
                        }
                      },
                      icon: Icon(
                        pickedImage == null
                            ? Icons.camera_alt
                            : Icons.remove_circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.normal),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: fName,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.normal),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: lName,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Phone
                Text(
                  'Phone',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                PhoneFormField(
                  countrySelectorNavigator:
                      const CountrySelectorNavigator.dialog(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.normal),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: phone,
                  textInputAction: TextInputAction.done,
                  validator: PhoneValidator.compose([
                    PhoneValidator.required(context),
                    PhoneValidator.valid(context),
                    PhoneValidator.validMobile(context),
                  ]),
                  onSubmitted: (value) => validate(),
                ),
                const SizedBox(height: 16),

                // Reset Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const ChangePassword(),
                    ),
                    child: const Text('change password'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),

      // Update
      actions: [
        ElevatedButton(
          onPressed: () => validate(),
          child: loading
              ? const CircularProgressIndicator()
              : const Text('Update'),
        )
      ],
    );

  validate() async {
    setState(() => loading = true);

    if (formKey.currentState!.validate()) {
      updateProfile(
        context: context,
        first: fName.text,
        last: lName.text,
        phone: phone.value,
        pickedImage: pickedImage,
        image: user.image,
      );
    }

    setState(() => loading = false);
  }
}
