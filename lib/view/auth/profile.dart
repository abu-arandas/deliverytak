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
  String? imageUrl;
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  PhoneController phone = PhoneController();

  bool loading = false;

  late UserModel user;

  @override
  void initState() {
    super.initState();

    singletUser(widget.id).listen((event) {
      setState(() {
        image = NetworkImage(event.image);
        imageUrl = event.image;
        fName = TextEditingController(text: event.name['first']);
        lName = TextEditingController(text: event.name['last']);
        email = TextEditingController(text: event.email);
        phone = PhoneController(initialValue: event.phone);
        user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pickedImage == null) {
      image = NetworkImage(noImage);
    }

    return AlertDialog(
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

                // Email
                Text(
                  'Email',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.normal),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* required';
                    } else if (!value.isEmail) {
                      return '* enter a valid email';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                Text(
                  'Phone',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                PhoneFormField(
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
  }

  validate() async {
    setState(() => loading = true);

    if (formKey.currentState!.validate()) {
      if (pickedImage != null) {
        // Storage
        await FirebaseStorage.instance
            .ref('users/')
            .child(widget.id)
            .putData(await pickedImage!.readAsBytes())

            // Image Url
            .then((value) => value.ref.getDownloadURL())

            // Firestore
            .then((value) => setState(() => imageUrl = value));
      }

      await usersCollection.doc(widget.id).update(
            user.copyWith(
              name: {'first': fName.text, 'last': lName.text},
              email: email.text,
              image: imageUrl ?? user.image,
              phone: phone.value,
            ).toJson(),
          );
    }

    setState(() => loading = false);
  }
}
