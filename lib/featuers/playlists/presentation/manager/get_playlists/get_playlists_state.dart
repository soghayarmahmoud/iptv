part of 'get_playlists_cubit.dart';

@immutable
sealed class GetPlaylistsState {}

final class GetPlaylistsInitial extends GetPlaylistsState {}

final class GetPlaylistsLoading extends GetPlaylistsState {}

final class GetPlaylistsSuccess extends GetPlaylistsState {
  final List<PlaylistModel> playlists;

  GetPlaylistsSuccess(this.playlists);
}

final class GetPlaylistsError extends GetPlaylistsState {
  final String message;
  GetPlaylistsError(this.message);
}