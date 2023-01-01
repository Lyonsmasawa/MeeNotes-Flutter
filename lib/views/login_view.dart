import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menotees/constants/routes.dart';
import 'package:menotees/services/auth/auth_exceptions.dart';
import 'package:menotees/services/auth/auth_service.dart';
import 'package:menotees/services/auth/bloc/auth_bloc.dart';
import 'package:menotees/services/auth/bloc/auth_event.dart';
import 'package:menotees/services/auth/bloc/auth_state.dart';
import 'package:menotees/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(
        title: const Text("Login"),
      ),
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
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is UserNotFoundAuthException) {
                  await showErrorDialog(context, 'wrong credentials!');
                } else if (state is WrongPasswordAuthException) {
                  await showErrorDialog(context, 'Wrong credentials!');
                } else if (state is GenericAuthException) {
                  await showErrorDialog(context, 'Authentication error');
                }
              }
            },
            child: TextButton(
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
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registeredRoute,
                  (route) => false,
                );
              },
              child: const Text("Not Registered yet? Register here!"))
        ],
      ),
    );
  }
}
