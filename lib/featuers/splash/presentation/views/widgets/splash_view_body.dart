import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/services/secure_storage.dart';
import 'package:iptv/core/utils/app_images.dart';
import 'package:iptv/featuers/home/presentation/views/home_view.dart';
import 'package:iptv/featuers/start/presentation/views/start_view.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  // TV-SAFE: Cache preloaded data for instant navigation
  String? _cachedToken;
  bool _cachedRememberMe = false;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    // Load data immediately
    _preloadData();
  }

  /// Load both values in PARALLEL
  Future<void> _preloadData() async {
    try {
      final results = await Future.wait<dynamic>([
        CacheHelper.instance.getData(key: 'rememberMeFlag'),
        getToken(),
      ]);

      _cachedRememberMe = (results[0] is bool) ? results[0] as bool : false;
      _cachedToken = results[1] as String?;
      _dataLoaded = true;

      debugPrint(
        '✅ Splash data preloaded: token=${_cachedToken != null}, remember=$_cachedRememberMe',
      );

      // Navigate immediately after data is loaded
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      debugPrint('⚠️ Error preloading data: $e');
      _cachedRememberMe = false;
      _cachedToken = null;
      _dataLoaded = true;

      // Navigate with defaults
      if (mounted) {
        _navigateToNextScreen();
      }
    }
  }

  /// Navigate using preloaded data (no async calls!)
  void _navigateToNextScreen() {
    if (!mounted) return;

    try {
      // Use cached data - instant navigation!
      if (_cachedToken != null &&
          _cachedToken!.isNotEmpty &&
          _cachedRememberMe) {
        debugPrint('✅ Navigating to HomeView (authenticated)');
        g.Get.off(
          () => const HomeView(),
          transition: g.Transition.fade,
          duration: const Duration(milliseconds: 400),
        );
      } else {
        debugPrint('✅ Navigating to StartView (not authenticated)');
        g.Get.off(
          () => const StartView(),
          transition: g.Transition.fade,
          duration: const Duration(milliseconds: 400),
        );
      }
    } catch (e) {
      debugPrint('❌ Navigation error: $e');
      if (mounted) {
        g.Get.off(
          () => const StartView(),
          transition: g.Transition.fade,
          duration: const Duration(milliseconds: 400),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TV-SAFE: Simple static splash screen with no animations
    return Center(
      child: Image.asset(Assets.imagesLogo, width: 300, height: 300),
    );
  }
}
