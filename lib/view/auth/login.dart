import '/exports.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscureText = true, loading = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
        // Title
        title: const Text('Enter your email and Password'),

        // Form
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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

                // Password
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'password',
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => obscureText = !obscureText),
                      icon:
                          Icon(obscureText ? Icons.remove_red_eye : Icons.lock),
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

                // Reset Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const Reset(),
                    ),
                    child: const Text('Forget my Password'),
                  ),
                ),

                // Login
                ElevatedButton(
                  onPressed: () => validate(),
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        ),

        // Register
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          const Text(
            'don\'t have an account',
            style: TextStyle(fontSize: 12),
          ),
          TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const Register(),
            ),
            child: const Text('register'),
          ),
        ],
      );

  validate() {
    setState(() => loading = true);

    if (formKey.currentState!.validate()) {
      try {
        FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (error) {
        errorSnackBar(error.message.toString());
      }
    }

    setState(() => loading = false);
  }
}
