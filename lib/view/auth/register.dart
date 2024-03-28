import 'dart:io';

import '/exports.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey();
  XFile? pickedImage;
  ImageProvider? image;
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  PhoneController phone = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.JO, nsn: ''));
  TextEditingController password = TextEditingController();
  bool obscureText = true, loading = false;

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
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'password',
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => obscureText = !obscureText),
                    icon: Icon(obscureText ? Icons.remove_red_eye : Icons.lock),
                  ),
                ),
                controller: password,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '* required';
                  } else if (value.length < 6) {
                    return '* must be 6 characters';
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (value) => validate(),
              ),
              const SizedBox(height: 16),

              // Register
              ElevatedButton(
                onPressed: () => validate(),
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
            ],
          ),
        ),
      ),

      // Login
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        const Text(
          'already have an account',
          style: TextStyle(fontSize: 12),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('login'),
        ),
      ],
    );
  }

  validate() async {
    setState(() => loading = true);

    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        String imageURL;

        if (pickedImage != null) {
          await FirebaseStorage.instance
              .ref('users/')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .putFile(File(pickedImage!.path));

          imageURL = await FirebaseStorage.instance
              .ref('users/')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .getDownloadURL();
        } else {
          imageURL = noImage;
        }

        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(UserModel(
              id: '',
              name: {'first': fName.text, 'last': lName.text},
              email: email.text,
              password: password.text,
              image: imageURL,
              phone: phone.value,
              role: UserRole.client,
            ).toJson());

        Navigator.pop;
        Navigator.pop;
      } on FirebaseAuthException catch (error) {
        errorSnackBar(error.message.toString());
      }
    }

    setState(() => loading = false);
  }
}
