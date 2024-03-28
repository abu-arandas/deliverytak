import '/exports.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController password = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) => AlertDialog(
        // Title
        title: const Text('Enter your new Password'),

        // Form
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: TextFormField(
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
          ),
        ),

        // Register
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => validate(),
            child: const Text('register'),
          ),
        ],
      );

  void validate() {
    if (formKey.currentState!.validate()) {
      try {
        FirebaseAuth.instance.currentUser!.updatePassword(password.text);

        Navigator.pop(context);
        Navigator.pop(context);
      } on FirebaseAuthException catch (error) {
        errorSnackBar(error.message.toString());
      }
    }
  }
}
