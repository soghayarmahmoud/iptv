part of 'get_movies_cubit.dart';

@immutable
sealed class GetMoviesState {}

final class GetMoviesInitial extends GetMoviesState {}

final class GetMoviesLoading extends GetMoviesState {}

final class GetMoviesSuccess extends GetMoviesState {
  final MoviesContentResponse moviesContentResponse;
  GetMoviesSuccess(this.moviesContentResponse);
}

final class GetMoviesError extends GetMoviesState {
  final String error;
  GetMoviesError(this.error);
}