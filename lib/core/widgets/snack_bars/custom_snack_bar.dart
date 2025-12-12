import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  showCustomSnackBar(
      {required BuildContext context,
      required String message,
      required AnimatedSnackBarType type}) {
    AnimatedSnackBar.material(
      message,
      type: type,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomCenter,
      duration: const Duration(seconds: 1),
    ).show(context);
  }
}