import '/exports.dart';

class Reset extends StatefulWidget {
  const Reset({super.key});

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) => AlertDialog(
        // Title
        title: const Text('Enter your email then check your inbox'),

        // Form
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'email',
                prefixIcon: Icon(Icons.email),
              ),
              controller: email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return '* required';
                } else if (!value.isEmail) {
                  return '* enter a valid email';
                } else {
                  return null;
                }
              },
              onFieldSubmitted: (value) => validate(),
            ),
          ),
        ),

        // Register
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => validate(),
            child: const Text('register'),
          ),
        ],
      );

  void validate() {
    if (formKey.currentState!.validate()) {
      try {
        FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

        Navigator.pop(context);
        Navigator.pop(context);
      } on FirebaseAuthException catch (error) {
        errorSnackBar(error.message.toString());
      }
    }
  }
}
