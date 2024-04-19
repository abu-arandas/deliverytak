import '/exports.dart';

class Reset extends StatefulWidget {
  const Reset({super.key});

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController email = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
        // Title
        title: const Text('Enter your email then check your inbox'),

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
                ],
              ),
            ),
          ),
        ),

        // Reset
        actions: [
          ElevatedButton(
            onPressed: () => validate(),
            child: loading
                ? const CircularProgressIndicator()
                : const Text('reset'),
          ),
        ],
      );

  void validate() {
    setState(() => loading = true);

    if (formKey.currentState!.validate()) {
      try {
        FirebaseAuth.instance
            .sendPasswordResetEmail(email: email.text)
            .then((value) => page(context: context, page: const Main()));
      } catch (error) {
        errorSnackBar(context, error.toString());
      }
    }

    setState(() => loading = false);
  }
}
