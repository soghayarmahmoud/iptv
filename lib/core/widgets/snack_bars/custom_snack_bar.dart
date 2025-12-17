import 'package:flutter/material.dart';

class CustomSnackBar {
  showCustomSnackBar({
    required BuildContext context,
    required String message,
    required SnackBarType type,
  }) {
    final backgroundColor = type == SnackBarType.error
        ? Colors.red
        : type == SnackBarType.warning
        ? Colors.orange
        : Colors.green;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

enum SnackBarType { success, error, warning, info }
