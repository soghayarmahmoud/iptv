part of 'get_eposide_stream_cubit.dart';

@immutable
sealed class GetEposideStreamState {}

final class GetEposideStreamInitial extends GetEposideStreamState {}

final class GetEposideStreamLoading extends GetEposideStreamState {}
final class GetEposideStreamSuccess extends GetEposideStreamState {
  final EpisodeStreamResponse episodeStreamResponse;
  GetEposideStreamSuccess(this.episodeStreamResponse);
}
final class GetEposideStreamError extends GetEposideStreamState {
  final String error;
  GetEposideStreamError(this.error);
}