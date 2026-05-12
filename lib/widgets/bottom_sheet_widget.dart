import 'package:flutter/material.dart';

class BaseBottomSheetWidget extends StatelessWidget {
  final String title;
  final String content;
  final String primaryButtonText;
  final VoidCallback? onPrimaryAction;

  const BaseBottomSheetWidget({
    super.key,
    required this.title,
    required this.content,
    required this.primaryButtonText,
    this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(content),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (onPrimaryAction != null) onPrimaryAction!();
              Navigator.of(context).pop();
            },
            child: Text(primaryButtonText),
          ),
          const SizedBox(height: 16), // Safe area margin
        ],
      ),
    );
  }
}
