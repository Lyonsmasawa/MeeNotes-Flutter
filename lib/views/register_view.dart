import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menotees/constants/routes.dart';
import 'package:menotees/services/auth/auth_exceptions.dart';
import 'package:menotees/services/auth/auth_service.dart';
import 'package:menotees/services/auth/bloc/auth_bloc.dart';
import 'package:menotees/services/auth/bloc/auth_event.dart';
import 'package:menotees/services/auth/bloc/auth_state.dart';
import 'package:menotees/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegister) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'email already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid Email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please create an account to get started!'),
              TextField(
                controller: _email,
                autocorrect: false,
                autofocus: true,
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
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventRegister(
                                email,
                                password,
                              ),
                            );
                        // try {
                        //   await AuthService.firebase().createUser(
                        //     email: email,
                        //     password: password,
                        //   );
                        //   AuthService.firebase().sendEmailVerification();
                        //   Navigator.of(context).pushNamed(verifyEmailRoute);
                        // } on WeakPasswordAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Invalid Password',
                        //   );
                        // } on EmailAlreadyInUseAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'user already exists',
                        //   );
                        // } on InvalidEmailAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Please enter a valid email',
                        //   );
                        // } on GenericAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Registration failed',
                        //   );
                        // }
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                        onPressed: () {
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //   loginRoute,
                          //   (route) => false,
                          // );
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        child: const Text("Already Registered? Login here!"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
