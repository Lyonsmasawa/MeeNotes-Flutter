import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menotees/constants/routes.dart';
import 'package:menotees/services/auth/auth_exceptions.dart';
import 'package:menotees/services/auth/auth_service.dart';
import 'package:menotees/services/auth/bloc/auth_bloc.dart';
import 'package:menotees/services/auth/bloc/auth_event.dart';
import 'package:menotees/services/auth/bloc/auth_state.dart';
import 'package:menotees/utilities/dialogs/error_dialog.dart';
import 'package:menotees/utilities/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  // CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'Cannot find a user with the entered credentials!');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials!');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'Please log in to your account in order to interact with and create notes!'),
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
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text('Login'),
              ),
              TextButton(
                  onPressed: () {
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   registeredRoute,
                    //   (route) => false,
                    // );
                    context.read<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                    log("pressed");
                  },
                  child: const Text("I forgot my password")),
              TextButton(
                  onPressed: () {
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   registeredRoute,
                    //   (route) => false,
                    // );
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventShouldRegister());
                  },
                  child: const Text("Not Registered yet? Register here!")),
            ],
          ),
        ),
      ),
    );
  }
}
