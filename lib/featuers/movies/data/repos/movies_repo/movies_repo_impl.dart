import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:iptv/core/errors/exceptions.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/core/services/api/dio_consumer.dart';
import 'package:iptv/core/services/api/endpoints.dart';
import 'package:iptv/featuers/movies/data/models/movie_category_model.dart';
import 'package:iptv/featuers/movies/data/models/movie_model.dart';
import 'package:iptv/featuers/movies/data/repos/movies_repo/movies_repo.dart';

class MoviesRepoImpl extends MoviesRepo {
  @override
  Future<Either<Failuer, MovieCategoriesResponse>> getMovieCategories(String playlistId) async {
    try {
    
      var response = await DioConsumer(dio: Dio()).get(Endpoints.getMovieCategories(playlistId));
      return Right(MovieCategoriesResponse.fromJson(response));
    } on ServerError catch (e) {
      return Left(Failuer(e.errorModel.errorMsg));
    } catch (e) {
      return Left(Failuer(e.toString()));
    }
  }
  @override
  Future<Either<Failuer, MoviesContentResponse>> getMovieItems(String categoryId, String playlistId) async {
    try {
     
      var response = await DioConsumer(dio: Dio()).get(Endpoints.getMovieItems(categoryId, playlistId));
      return Right(MoviesContentResponse.fromJson(response));
    } on ServerError catch (e) {
      return Left(Failuer(e.errorModel.errorMsg));
    } catch (e) {
      return Left(Failuer(e.toString()));
    }
  }

  @override
  Future<Either<Failuer, String>> getMovieConvertedUrlStream(String url) async {
    try {
      var response = await DioConsumer(
        dio: Dio(),
        customBaseUrl: 'http://45.130.229.5/'
      ).get(Endpoints.convertUrl(url));
      return Right(response['hls_playlist_stream']);
    } on ServerError catch (e) {
      return Left(Failuer(e.errorModel.errorMsg));
    } catch (e) {
      return Left(Failuer(e.toString()));
    }
  }
   
}