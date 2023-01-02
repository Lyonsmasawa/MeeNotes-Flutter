import 'package:flutter/material.dart';
import 'package:menotees/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password reset',
    content: 'We have sent a password reset link to your email',
    optionsBuilder: () => {
          'OK': null,
        },
  );
}
