// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:iptv/featuers/playlists/data/models/playlist_model.dart';
import 'package:iptv/featuers/playlists/data/repos/playlist_repo/playlist_repo_impl.dart';
import 'package:meta/meta.dart';

part 'get_playlists_state.dart';

class GetPlaylistsCubit extends Cubit<GetPlaylistsState> {
  GetPlaylistsCubit() : super(GetPlaylistsInitial());

  void getPlaylists() async {
    if (isClosed) return;
    emit(GetPlaylistsLoading());
    
    var response = await PlaylistRepoImpl().getPlaylists();
    
    if (isClosed) return;
    response.fold(
      (l) {
        if (isClosed) return;
        emit(GetPlaylistsError(l.message));
      },
      (r) {
        if (isClosed) return;
        emit(GetPlaylistsSuccess(r));
      },
    );
  }
}
