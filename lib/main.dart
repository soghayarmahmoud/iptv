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
  MediaKit.ensureInitialized();

  // Initialize CacheHelper for favorites and other cached data
  await CacheHelper.init();

  // Lock app to landscape mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set immersive mode to prevent orientation issues
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
      locale: isDeviceLanguageArabic() ? Locale('ar') : Locale('en'),
      home: const SplashView(),
    );
  }
}
