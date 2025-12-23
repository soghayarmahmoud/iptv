import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/utils/g_functions.dart';
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

  // Initialize MediaKit with error handling
  try {
    MediaKit.ensureInitialized();
  } catch (e) {
    debugPrint('MediaKit initialization warning: $e');
    // Continue even if MediaKit fails - some Android boxes don't support it
  }

  // Initialize CacheHelper for favorites and other cached data
  try {
    await CacheHelper.init();
  } catch (e) {
    debugPrint('CacheHelper initialization error: $e');
    // Continue with default empty cache
  }

  // Lock app to landscape mode only (for TV boxes)
  try {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } catch (e) {
    debugPrint('SystemChrome orientation error: $e');
  }

  // Set immersive mode for fullscreen on TV boxes
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  } catch (e) {
    debugPrint('SystemChrome immersive mode error: $e');
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
    debugPrint('SystemChrome UI overlay error: $e');
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => GetMovieStreamCubit()),
        BlocProvider(create: (context) => ChangePasswordCubit()),
        BlocProvider(create: (context) => GetIptvCategoriesCubit()),
        BlocProvider(create: (context) => GetIptvChannelsCubit()),
      ],
      child: const RemoteKeyHandler(child: MyApp()),
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
          child: child!,
        );
      },
      home: const SplashView(),
      // Global error handler for uncaught exceptions
      navigatorObservers: [_AppNavigatorObserver()],
    );
  }
}

class _AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('Navigated to: ${route.settings.name ?? 'Unknown'}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('Popped from: ${route.settings.name ?? 'Unknown'}');
  }
}
