part of 'get_movie_stream_cubit.dart';

@immutable
sealed class GetMovieStreamState {}

final class GetMovieStreamInitial extends GetMovieStreamState {}

final class GetMovieStreamLoading extends GetMovieStreamState {}

final class GetMovieStreamError extends GetMovieStreamState {
  final String message;

  GetMovieStreamError(this.message);
}

final class GetMovieStreamSuccess extends GetMovieStreamState {
  final String streamUrl;
  final String imageUrl;
  final String name;
  final String? id;
  final String? type;
  
  GetMovieStreamSuccess(this.streamUrl, this.imageUrl, this.name, {this.id, this.type});
}
