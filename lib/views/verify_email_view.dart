import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menotees/constants/routes.dart';
import 'package:menotees/services/auth/auth_service.dart';
import 'package:menotees/services/auth/bloc/auth_bloc.dart';
import 'package:menotees/services/auth/bloc/auth_event.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Column(
        children: [
          const Text(
              "We've already sent you an email. please click on it to verify your account"),
          const Text("If you haven't received an email yet please click below"),
          TextButton(
              onPressed: () async {
                // await AuthService.firebase().sendEmailVerification();
                context.read<AuthBloc>().add(AuthEventSendEmailVerification());
              },
              child: const Text("send email verification")),
          TextButton(
              onPressed: () async {
                // await AuthService.firebase().logOut();
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil(registeredRoute, (route) => false);

                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text("Restart")),
        ],
      ),
    );
  }
}
