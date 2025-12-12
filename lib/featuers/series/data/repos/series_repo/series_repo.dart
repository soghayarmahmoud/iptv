import 'package:dartz/dartz.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/featuers/series/data/models/eposide_model.dart';
import 'package:iptv/featuers/series/data/models/eposide_stream_model.dart';
import 'package:iptv/featuers/series/data/models/series_categories_model.dart';
import 'package:iptv/featuers/series/data/models/series_model.dart';

abstract class SeriesRepo {
    Future<Either<Failuer, SeriesCategoriesModel>> getSeriesCategories(String playlistId);
    Future<Either<Failuer, SeriesContentResponse>> getSeries(String categoryId , String playlistId);

    Future<Either<Failuer,SeriesDetailResponse>> getEposides(String seriesId , String playlistId);

    Future<Either<Failuer,EpisodeStreamResponse>> getEposideStream(String seriesId, String eposideId , String playlistId);
}

