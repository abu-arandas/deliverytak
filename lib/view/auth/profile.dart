import 'dart:io';

import '/exports.dart';

class Profile extends StatefulWidget {
  final UserModel user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<FormState> formKey = GlobalKey();
  XFile? pickedImage;
  ImageProvider? image;
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  PhoneController phone = PhoneController();

  @override
  void initState() {
    super.initState();

    setState(() {
      image = NetworkImage(widget.user.image);
      fName = TextEditingController(text: widget.user.name['first']);
      lName = TextEditingController(text: widget.user.name['last']);
      email = TextEditingController(text: widget.user.email);
      phone = PhoneController(initialValue: widget.user.phone);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pickedImage == null) {
      image = NetworkImage(noImage);
    } else {
      image = FileImage(File(pickedImage!.path));
    }

    return AlertDialog(
      // Title
      title: const Text('Enter your informations to Complete'),

      // Form
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: image!,
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.transparent.withOpacity(0.5), BlendMode.darken),
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
                          .then((value) => setState(() => pickedImage = value));
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
              const SizedBox(height: 16),

              // Name
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
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
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      controller: lName,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'email',
                  prefixIcon: Icon(Icons.email),
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
              PhoneFormField(
                decoration: const InputDecoration(
                  labelText: 'phone',
                  prefixIcon: Icon(Icons.phone),
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

              // Register
              ElevatedButton(
                onPressed: () => validate(),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  validate() {
    if (formKey.currentState!.validate()) {
      try {
        String newImage;

        if (pickedImage != null) {
          FirebaseStorage.instance
              .ref('users/')
              .child(widget.user.id)
              .putFile(File(pickedImage!.path));

          newImage = FirebaseStorage.instance
              .ref('users/')
              .child(widget.user.id)
              .getDownloadURL()
              .toString();
        } else {
          newImage = noImage;
        }

        UserController.instance.usersCollection
            .doc(widget.user.id)
            .update(UserModel(
              id: '',
              name: {'first': fName.text, 'last': lName.text},
              email: email.text,
              image: newImage,
              phone: phone.value,
              role: widget.user.role,
            ).toJson());

        Navigator.pop(context);
        Navigator.pop(context);
      } on FirebaseAuthException catch (error) {
        errorSnackBar(error.message.toString());
      }
    }
  }
}
