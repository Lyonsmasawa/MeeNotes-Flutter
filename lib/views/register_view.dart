import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:menotees/constants/routes.dart';

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
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == "weak-password") {
                  devtools.log('Weak password');
                } else if (e.code == "email-already-in-use") {
                  devtools.log("user already exists");
                } else if (e.code == "invalid-email") {
                  devtools.log("Please enter a valid email");
                } else {
                  devtools.log("Something happened");
                }
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
