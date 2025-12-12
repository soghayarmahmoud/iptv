import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:iptv/core/errors/exceptions.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/core/services/api/dio_consumer.dart';
import 'package:iptv/core/services/api/endpoints.dart';
import 'package:iptv/featuers/playlists/data/models/playlist_model.dart';
import 'package:iptv/featuers/playlists/data/repos/playlist_repo/playlist_repo.dart';

class PlaylistRepoImpl extends PlaylistRepo {
  @override
  Future<Either<Failuer, List<PlaylistModel>>> getPlaylists() async {
   try {
  var response = await DioConsumer(dio: Dio()).get(Endpoints.getPlaylists);
  return Right(
    List<PlaylistModel>.from(response.map((e) => PlaylistModel.fromJson(e)))
        .where((playlist) => playlist.isActive)
        .toList(),
  );
} on ServerError catch (e) {
  return Left(Failuer(e.errorModel.errorMsg));
} catch (e) {
  return Left(Failuer('An unknown error occurred'));
}
  }
}