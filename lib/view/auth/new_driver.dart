// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

class NewDrivwer extends StatefulWidget {
  const NewDrivwer({super.key});

  @override
  State<NewDrivwer> createState() => _NewDrivwerState();
}

class _NewDrivwerState extends State<NewDrivwer> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController email = TextEditingController();
  PhoneController phone = PhoneController(null);
  TextEditingController password = TextEditingController();
  bool obscureText = true, loading = false;

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
                  PhoneInput(
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
                    textInputAction: TextInputAction.next,
                    validator: PhoneValidator.compose([
                      PhoneValidator.required(),
                      PhoneValidator.valid(),
                      PhoneValidator.validMobile(),
                    ]),
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
                        onPressed: () =>
                            setState(() => obscureText = !obscureText),
                        icon: Icon(
                            obscureText ? Icons.remove_red_eye : Icons.lock),
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
      newDriver(
        context: context,
        email: email.text,
        phone: phone.value!,
        password: password.text,
      );
    }

    setState(() => loading = false);
  }
}
