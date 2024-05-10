import '/exports.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController password = TextEditingController();

  bool obscureText = true, loading = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
        // Title
        title: const Text('Enter your new Password'),

        // Form
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
        ),

        // Register
        actions: [
          ElevatedButton(
            onPressed: () => validate(),
            child: loading
                ? const CircularProgressIndicator()
                : const Text('register'),
          ),
        ],
      );

  void validate() {
    setState(() => loading = true);

    if (formKey.currentState!.validate()) {
      updatePassword(context: context, password: password.text);
    }

    setState(() => loading = false);
  }
}
