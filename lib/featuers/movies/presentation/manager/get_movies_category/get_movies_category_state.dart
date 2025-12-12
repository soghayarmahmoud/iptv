part of 'get_movies_category_cubit.dart';

@immutable
sealed class GetMoviesCategoryState {}

final class GetMoviesCategoryInitial extends GetMoviesCategoryState {}

final class GetMoviesCategoryLoading extends GetMoviesCategoryState {}

final class GetMoviesCategorySuccess extends GetMoviesCategoryState {
  final MovieCategoriesResponse movieCategoriesResponse;
  GetMoviesCategorySuccess(this.movieCategoriesResponse);
}

final class GetMoviesCategoryError extends GetMoviesCategoryState {
  final String error;
  GetMoviesCategoryError(this.error);
}