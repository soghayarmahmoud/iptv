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
      // Switch to landscape after splash is fully replaced
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('Error setting landscape orientation in StartView: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const StartViewBody());
  }
}
