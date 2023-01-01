import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menotees/constants/routes.dart';
import 'package:menotees/firebase_options.dart';
import 'package:menotees/services/auth/auth_service.dart';
import 'package:menotees/services/auth/bloc/auth_bloc.dart';
import 'package:menotees/services/auth/bloc/auth_event.dart';
import 'package:menotees/services/auth/bloc/auth_state.dart';
import 'package:menotees/services/auth/firebase_auth_provider.dart';
import 'package:menotees/views/login_view.dart';
import 'package:menotees/views/notes/create_update_note_view.dart';
import 'package:menotees/views/notes/notes_view.dart';
import 'package:menotees/views/register_view.dart';
import 'package:menotees/views/verify_email_view.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//       routes: {
//         loginRoute: (context) => const LoginView(),
//         registeredRoute: (context) => const RegisterViewState(),
//         notesRoute: (context) => const NotesView(),
//         verifyEmailRoute: (context) => const VerifyEmail(),
//         createOrUpdateRoute: (context) => const CreateUpdateNoteView(),
//       },
//     ),
//   );
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmail();
//               }
//             } else {
//               return const LoginView();
//             }
//           // if (user?.emailVerified ?? false)
//           default:
//             return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registeredRoute: (context) => const RegisterViewState(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmail(),
        createOrUpdateRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmail();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
