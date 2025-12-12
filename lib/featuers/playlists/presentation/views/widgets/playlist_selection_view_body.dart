import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/core/widgets/placeholder_lists.dart';
import 'package:iptv/featuers/playlists/presentation/manager/get_playlists/get_playlists_cubit.dart';
import 'package:iptv/featuers/playlists/presentation/views/widgets/list_view_of_playlists.dart';
import 'package:iptv/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlaylistSelectionViewBody extends StatefulWidget {
  const PlaylistSelectionViewBody({super.key, required this.live, required this.movies, required this.series});
   final bool live , movies , series ;

  @override
  State<PlaylistSelectionViewBody> createState() =>
      _PlaylistSelectionViewBodyState();
}

class _PlaylistSelectionViewBodyState extends State<PlaylistSelectionViewBody> {


  @override
  void initState() {
    super.initState();
    context.read<GetPlaylistsCubit>().getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondaryColorTheme, AppColors.mainColorTheme],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: SizedBox(
          child: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        S.current.playlist_selection,
                        style: TextStyles.font22ExtraBold(
                          context,
                        ).copyWith(color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),
              BlocBuilder<GetPlaylistsCubit, GetPlaylistsState>(
                builder: (context, state) {
                  if (state is GetPlaylistsLoading) {
                    return Skeletonizer(
                      effect: ShimmerEffect(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        duration: const Duration(seconds: 1),
                      ),
                      enabled: true,
                      child: ListViewOfPlaylists(playlists: playlists , live:widget.live, movies: widget.movies , series: widget.series,),
                    );
                  }
                  if (state is GetPlaylistsSuccess) {
                    if(state.playlists.isEmpty){
                      return Center(child: Text(S.current.no_active_playlists , style: TextStyles.font20Bold(context).copyWith(color: AppColors.whiteColor),) ,);
                    }
                    else{
                      return ListViewOfPlaylists(playlists: state.playlists ,live:widget.live, movies: widget.movies , series: widget.series,);
                    }
                  }
                
                  return Skeletonizer(
                    effect: ShimmerEffect(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      duration: const Duration(seconds: 1),
                    ),
                    enabled: true,
                    child: ListViewOfPlaylists(playlists: playlists,live:widget.live, movies: widget.movies , series: widget.series,),
                  );
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
