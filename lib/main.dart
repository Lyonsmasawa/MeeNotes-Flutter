import 'package:flutter/material.dart';
import 'package:menotees/constants/routes.dart';
import 'package:menotees/firebase_options.dart';
import 'package:menotees/services/auth/auth_service.dart';
import 'package:menotees/views/login_view.dart';
import 'package:menotees/views/notes_view.dart';
import 'package:menotees/views/register_view.dart';
import 'package:menotees/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registeredRoute: (context) => const RegisterViewState(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmail(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginView();
            }
          // if (user?.emailVerified ?? false)
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
