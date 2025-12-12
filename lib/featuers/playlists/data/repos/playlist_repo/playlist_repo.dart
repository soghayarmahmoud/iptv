import 'package:dartz/dartz.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/featuers/playlists/data/models/playlist_model.dart';

abstract class PlaylistRepo {
  Future<Either<Failuer, List<PlaylistModel>>> getPlaylists();
}