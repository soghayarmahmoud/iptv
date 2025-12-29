import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/utils/g_functions.dart';
import 'package:iptv/core/utils/memory_manager.dart';
import 'package:iptv/featuers/live_tv/presentation/manager/get_iptv_categories/get_iptv_categories_cubit.dart';
import 'package:iptv/featuers/live_tv/presentation/manager/get_iptv_channels/get_iptv_channels_cubit.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movie_stream/get_movie_stream_cubit.dart';
import 'package:iptv/featuers/settings/presentation/manager/change_password/change_password_cubit.dart';
import 'package:iptv/featuers/splash/presentation/views/splash_view.dart';
import 'package:iptv/featuers/start/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:iptv/generated/l10n.dart';
import 'package:media_kit/media_kit.dart';
import 'core/widgets/remote_key_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TV-SAFE: Initialize MediaKit synchronously BEFORE runApp
  try {
    MediaKit.ensureInitialized();
    debugPrint('✅ MediaKit initialized successfully');
  } catch (e) {
    debugPrint('⚠️ MediaKit initialization warning: $e');
  }

  // Initialize memory manager to detect low-end devices
  try {
    await MemoryManager().initialize();
  } catch (e) {
    debugPrint('⚠️ MemoryManager initialization error: $e');
  }

  // Adjust image cache based on device capabilities
  if (MemoryManager().isLowEndDevice) {
    debugPrint('🔧 Low-end device detected - reducing cache sizes');
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;
    PaintingBinding.instance.imageCache.maximumSize = 50;
  } else {
    debugPrint('✅ Normal device - using default cache sizes');
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024;
    PaintingBinding.instance.imageCache.maximumSize = 100;
  }

  // Initialize CacheHelper synchronously
  try {
    await CacheHelper.init();
    debugPrint('✅ CacheHelper initialized successfully');
  } catch (e) {
    debugPrint('⚠️ CacheHelper initialization error: $e');
  }

  // Lock app to landscape mode only (for TV boxes)
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } catch (e) {
    debugPrint('⚠️ Orientation lock failed: $e');
  }

  // TV-SAFE: Use manual SystemUiMode with no overlays
  try {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  } catch (e) {
    debugPrint('⚠️ SystemUiMode configuration failed: $e');
  }

  // Configure system UI for TV boxes
  try {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  } catch (e) {
    debugPrint('⚠️ SystemUiOverlayStyle configuration failed: $e');
  }

  // Start app IMMEDIATELY with all critical services initialized
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => GetMovieStreamCubit()),
        BlocProvider(create: (context) => ChangePasswordCubit()),
        BlocProvider(create: (context) => GetIptvCategoriesCubit()),
        BlocProvider(create: (context) => GetIptvChannelsCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      locale: isDeviceLanguageArabic()
          ? const Locale('ar')
          : const Locale('en'),
      // Disable text scaling for TV boxes to maintain proper font sizes
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: RemoteKeyHandler(child: child!),
        );
      },
      home: const SplashView(),
    );
  }
}
