import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context, {required String title, required String body, String confirmText = 'Yes', String cancelText = 'Cancel'}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
