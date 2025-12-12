import 'package:dartz/dartz.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/featuers/movies/data/models/movie_category_model.dart';
import 'package:iptv/featuers/movies/data/models/movie_model.dart';

abstract class MoviesRepo {
    Future<Either<Failuer, MovieCategoriesResponse>> getMovieCategories(String playlistId);
    Future<Either<Failuer, MoviesContentResponse>> getMovieItems(String categoryId, String playlistId);
    Future<Either<Failuer , String>> getMovieConvertedUrlStream(String url);
}
