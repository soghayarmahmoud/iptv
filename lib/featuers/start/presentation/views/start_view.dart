import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/start_view_body.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  void initState() {
    super.initState();
    _setLandscapeOrientation();
  }

  void _setLandscapeOrientation() {
    try {
      // TV-SAFE: Switch to landscape after splash is fully replaced
      // Wrap in try-catch to prevent crashes on old APIs
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('⚠️ Error setting landscape orientation in StartView: $e');
      // Continue - app will work in default orientation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const StartViewBody());
  }
}
