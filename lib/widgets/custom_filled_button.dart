import 'package:flutter/material.dart';

// Reusable Button Component
class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(text));
  }
}
