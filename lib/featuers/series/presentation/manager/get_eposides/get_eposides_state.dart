part of 'get_eposides_cubit.dart';

@immutable
sealed class GetEposidesState {}

final class GetEposidesInitial extends GetEposidesState {}

final class GetEposidesLoading extends GetEposidesState {}
final class GetEposidesSuccess extends GetEposidesState {
  final SeriesDetailResponse seriesDetailResponse;
  GetEposidesSuccess(this.seriesDetailResponse);
}
final class GetEposidesError extends GetEposidesState {
  final String error;
  GetEposidesError(this.error);
}