// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:iptv/core/errors/exceptions.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/core/services/api/dio_consumer.dart';
import 'package:iptv/core/services/api/endpoints.dart';
import 'package:iptv/featuers/series/data/models/eposide_model.dart';
import 'package:iptv/featuers/series/data/models/eposide_stream_model.dart';
import 'package:iptv/featuers/series/data/models/series_categories_model.dart';
import 'package:iptv/featuers/series/data/models/series_model.dart';
import 'package:iptv/featuers/series/data/repos/series_repo/series_repo.dart';

class SeriesRepoImpl implements SeriesRepo {
  @override
  Future<Either<Failuer, SeriesCategoriesModel>> getSeriesCategories(
    String playlistId,
  ) async {
    try {
      var response = await DioConsumer(
        dio: Dio(),
      ).get(Endpoints.getSeriesCategories(playlistId));
      return Right(SeriesCategoriesModel.fromJson(response));
    } on ServerError catch (e) {
      return Left(Failuer(e.errorModel.errorMsg));
    } catch (e) {
      return Left(Failuer(e.toString()));
    }
  }

  @override
  Future<Either<Failuer, SeriesContentResponse>> getSeries(
    String categoryId,
    String playlistId,
  ) async {
    try {
      var response = await DioConsumer(
        dio: Dio(),
      ).get(Endpoints.getSeriesItem(categoryId, playlistId));
      return Right(SeriesContentResponse.fromJson(response));
    } on ServerError catch (e) {
      return Left(Failuer(e.errorModel.errorMsg));
    } catch (e) {
      return Left(Failuer(e.toString()));
    }
  }

  @override
  Future<Either<Failuer, SeriesDetailResponse>> getEposides(
    String seriesId,
    String playlistId,
  ) async {
    try {
      var response = await DioConsumer(
        dio: Dio(),
      ).get(Endpoints.getSeriesDetail(seriesId, playlistId));
      return Right(SeriesDetailResponse.fromJson(response));
    } on ServerError catch (e) {
      return Left(Failuer(e.errorModel.errorMsg));
    } catch (e) {
      return Left(Failuer(e.toString()));
    }
  }

  @override
  Future<Either<Failuer, EpisodeStreamResponse>> getEposideStream(
    String seriesId,
    String eposideId,
    String playlistId,
  ) async {
    try {
      var response = await DioConsumer(
        dio: Dio(),
      ).get(Endpoints.getEposideStream(seriesId, playlistId, eposideId));

      EpisodeStreamResponse eposidStreamModel = EpisodeStreamResponse.fromJson(
        response,
      );
      String url = eposidStreamModel.episode.streamUrl;
      if (url.contains('.mp4')) {
        return Right(eposidStreamModel);

      } else {

        String parseUrl;
                    if(url.contains('.mkv')){
                      parseUrl = eposidStreamModel.episode.originalUrl!;
                    }else{
                      parseUrl = eposidStreamModel.episode.streamUrl;
                    }
                 
        var response = await DioConsumer(
          dio: Dio(),
          customBaseUrl: 'http://45.130.229.5/',
        ).get(Endpoints.convertUrl(parseUrl));
        eposidStreamModel.episode.streamUrl = response['hls_playlist_stream'];
      }

      return Right(eposidStreamModel);
    } on ServerError catch (e) {
      return Left(Failuer(e.errorModel.errorMsg));
    } catch (e) {
      return Left(Failuer(e.toString()));
    }
  }
}
