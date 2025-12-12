import 'package:animated_snack_bar/animated_snack_bar.dart';
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
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FavShowViews extends StatefulWidget {
  const FavShowViews({super.key});

  @override
  State<FavShowViews> createState() => _FavShowViewsState();
}

class _FavShowViewsState extends State<FavShowViews> {
  @override
  void initState() {
    super.initState();
    // Ensure landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
            CustomSnackBar().showCustomSnackBar(context: context, message: state.message, type: AnimatedSnackBarType.error);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(inAsyncCall: state is GetMovieStreamLoading ,color: Colors.transparent ,progressIndicator: CircularProgressIndicator(color: AppColors.yellowColor,), child: Scaffold(body: FavShowViewsBody()));
        },
      ),
    );
  }
}
