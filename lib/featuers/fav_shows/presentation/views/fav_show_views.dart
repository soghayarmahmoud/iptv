import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/widgets/snack_bars/custom_snack_bar.dart';
import 'package:iptv/featuers/fav_shows/presentation/views/widgets/fav_show_views_body.dart';
import 'package:iptv/featuers/live_tv/presentation/views/tv_player_view.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movie_stream/get_movie_stream_cubit.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movies/get_movies_cubit.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movies_category/get_movies_category_cubit.dart';

class FavShowViews extends StatefulWidget {
  const FavShowViews({super.key});

  @override
  State<FavShowViews> createState() => _FavShowViewsState();
}

class _FavShowViewsState extends State<FavShowViews> {
  @override
  void initState() {
    super.initState();
    // TV-SAFE: Ensure landscape orientation with error handling
    try {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('⚠️ Failed to set landscape orientation: $e');
    }

    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {
      debugPrint('⚠️ Failed to set immersive mode: $e');
      try {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      } catch (e2) {
        debugPrint('⚠️ All system UI modes failed: $e2');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetMoviesCategoryCubit>(
          create: (context) => GetMoviesCategoryCubit(),
        ),
        BlocProvider<GetMoviesCubit>(create: (context) => GetMoviesCubit()),
      ],
      child: BlocConsumer<GetMovieStreamCubit, GetMovieStreamState>(
        listener: (context, state) {
          if (state is GetMovieStreamSuccess) {
            g.Get.to(
              () => TvPlayerView(
                isLive: false,
                imageUrl: state.imageUrl,
                channelName: state.name,
                streamUrl: state.streamUrl,
                id: state.id,
                type: state.type,
              ),
              transition: g.Transition.fade,
              duration: const Duration(milliseconds: 300),
            );
          }
          if (state is GetMovieStreamError) {
            CustomSnackBar().showCustomSnackBar(
              context: context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(body: FavShowViewsBody()),
              if (state is GetMovieStreamLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.yellowColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
