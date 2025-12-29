import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptv/featuers/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _setLandscapeOrientation();
  }

  void _setLandscapeOrientation() {
    // TV-SAFE: Wrap SystemChrome calls in try-catch to prevent crashes on old APIs
    try {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('⚠️ Failed to set landscape orientation in HomeView: $e');
      // Continue - app will work in default orientation
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: HomeViewBody());
  }
}
