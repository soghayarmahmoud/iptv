// TV Box utilities and configurations
import 'package:flutter/material.dart';

/// Helper class for TV-specific configurations and utilities
class TVUtils {
  // TV box safe area margins (accounting for overscan)
  static const double tvSafeMargin = 48.0;

  // Minimum touch target size for TV remote navigation
  static const double tvMinimumTouchSize = 48.0;

  /// Get TV-safe padding for content
  static EdgeInsets getTVSafePadding(BuildContext context) {
    return EdgeInsets.all(tvSafeMargin);
  }

  /// Get responsive font size for TV boxes
  /// Larger base sizes to accommodate viewing distance
  static double getResponsiveFontSize(
    BuildContext context, {
    required double baseSize,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // For TV boxes, we use a larger scaling factor
    // Typical TV boxes: 1920x1080 or 1280x720
    final scaleFactor = (screenWidth + screenHeight) / 3000;

    return baseSize * (scaleFactor.clamp(0.8, 1.5));
  }

  /// Get TV-optimized text style
  static TextStyle getTVTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    Color color = Colors.white,
    String fontFamily = 'Poppins',
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
      // Improved readability for TV screens
      height: 1.3,
      letterSpacing: 0.5,
    );
  }

  /// Get heading style for TV
  static TextStyle getTVHeadingStyle(BuildContext context) {
    return getTVTextStyle(
      fontSize: getResponsiveFontSize(context, baseSize: 28),
      fontWeight: FontWeight.bold,
    );
  }

  /// Get subtitle style for TV
  static TextStyle getTVSubtitleStyle(BuildContext context) {
    return getTVTextStyle(
      fontSize: getResponsiveFontSize(context, baseSize: 18),
      fontWeight: FontWeight.w600,
    );
  }

  /// Get body text style for TV
  static TextStyle getTVBodyStyle(BuildContext context) {
    return getTVTextStyle(
      fontSize: getResponsiveFontSize(context, baseSize: 16),
      fontWeight: FontWeight.normal,
    );
  }

  /// Get caption style for TV
  static TextStyle getTVCaptionStyle(BuildContext context) {
    return getTVTextStyle(
      fontSize: getResponsiveFontSize(context, baseSize: 14),
      fontWeight: FontWeight.w500,
      color: Colors.grey[400] ?? Colors.grey,
    );
  }

  /// Check if running on TV device
  static bool isTV(BuildContext context) {
    // Check screen diagonal
    final size = MediaQuery.of(context).size;
    final diagonal =
        Math.sqrt(size.width * size.width + size.height * size.height) /
        MediaQuery.of(context).devicePixelRatio;

    // TV screens are typically 32" and above (~7+ inches diagonal at standard density)
    return diagonal > 6.5;
  }

  /// Get TV-safe button size
  static Size getTVButtonSize(BuildContext context) {
    return Size(MediaQuery.of(context).size.width * 0.25, 72);
  }

  /// Get TV-optimized padding for buttons
  static EdgeInsets getTVButtonPadding() {
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
  }

  /// Get spacing between items on TV
  static double getTVItemSpacing(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05;
  }

  /// Ensure focus is visible on TV by highlighting
  static BoxDecoration getTVFocusDecoration({
    Color focusColor = const Color(0xFFFFD700), // Gold
    double borderRadius = 8,
    double borderWidth = 3,
  }) {
    return BoxDecoration(
      border: Border.all(color: focusColor, width: borderWidth),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: focusColor.withValues(alpha: 0.5),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
  }

  /// Disable text scaling for TV consistency
  static TextScaleFactor getTextScaleFactor() {
    return TextScaleFactor.disableScaling;
  }
}

/// Custom extension for better TV readability
extension TVExtension on TextStyle {
  TextStyle tvOptimized() {
    return copyWith(height: 1.3, letterSpacing: 0.5);
  }
}

enum TextScaleFactor { disableScaling, allowScaling }

// Math utility (import math: package or define locally)
class Math {
  static double sqrt(double value) {
    return value < 0 ? 0 : _sqrt(value);
  }

  static double _sqrt(double value) {
    if (value == 0) return 0;
    double x = value;
    double y = (x + 1) / 2;
    while (y < x) {
      x = y;
      y = (x + value / x) / 2;
    }
    return x;
  }
}
