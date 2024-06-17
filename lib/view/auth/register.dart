// ignore_for_file: use_build_context_synchronously

import '/exports.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey();
  String image = noImage;
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  PhoneController phone = PhoneController();
  TextEditingController password = TextEditingController();
  bool obscureText = true, loading = false;

  @override
  Widget build(BuildContext context) => AuthScaffold(
        title: 'Register',
        subTitle: 'enter your informations to get access',
        form: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      controller: fName,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.normal),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                      ),
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
                      controller: lName,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.normal),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                      ),
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
                  PhoneValidator.required(context),
                  PhoneValidator.valid(context),
                  PhoneValidator.validMobile(context),
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
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => validate(),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                  ),
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                ),
              ),

              // Log In
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () => page(
                        context: context,
                        page: const Login(),
                      ),
                      child: const Text('Log In'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  validate() async {
    setState(() => loading = true);

    if (formKey.currentState!.validate()) {
      currentUser(
        context: context,
        name: {'first': fName.text, 'last': lName.text},
        email: email.text,
        password: password.text,
        phone: phone.value,
      );
    }

    setState(() => loading = false);
  }
}
