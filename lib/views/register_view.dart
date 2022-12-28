import 'package:flutter/material.dart';
import 'package:menotees/constants/routes.dart';
import 'package:menotees/services/auth/auth_exceptions.dart';
import 'package:menotees/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';

class RegisterViewState extends StatefulWidget {
  const RegisterViewState({super.key});

  @override
  State<RegisterViewState> createState() => _RegisterViewStateState();
}

class _RegisterViewStateState extends State<RegisterViewState> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Invalid Password',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'user already exists',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Please enter a valid email',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Registration failed',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text("Already Registered? Login here!"))
        ],
      ),
    );
  }
}
