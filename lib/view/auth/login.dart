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
  Widget build(BuildContext context) => AuthScaffold(
        title: 'Login',
        subTitle: 'enter your email and password',
        form: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Password
              Text(
                'Password',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
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
              const SizedBox(height: 16),

              // Login
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => validate(),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                  ),
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ),

              // Sign Up
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not have an account?'),
                    TextButton(
                      onPressed: () => page(
                        context: context,
                        page: const Register(),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  validate() {
    setState(() => loading = true);

    if (formKey.currentState!.validate()) {
      try {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: email.text,
              password: password.text,
            )
            .then((value) => page(context: context, page: const Main()));
      } on FirebaseException catch (error) {
        errorSnackBar(context, error.message.toString());
      }
    }

    setState(() => loading = false);
  }
}
