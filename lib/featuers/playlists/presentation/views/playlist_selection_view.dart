import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/featuers/playlists/presentation/manager/get_playlists/get_playlists_cubit.dart';
import 'package:iptv/featuers/playlists/presentation/views/widgets/playlist_selection_view_body.dart';

class PlaylistSelectionView extends StatelessWidget {
  const PlaylistSelectionView({super.key , this.live = false , this.movies = false , this.series = false});
  final bool live , movies , series ;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPlaylistsCubit()..getPlaylists(),
      child:  Scaffold(body: PlaylistSelectionViewBody(live: live , series: series ,movies: movies,)),
    );
  }
}
