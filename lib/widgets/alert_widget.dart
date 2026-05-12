import 'package:flutter/material.dart';

class BaseAlertWidget extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onDismiss;

  const BaseAlertWidget({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            if (onDismiss != null) onDismiss!();
            Navigator.of(context).pop();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
