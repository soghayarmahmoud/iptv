part of 'get_series_cubit.dart';

@immutable
sealed class GetSeriesState {}

final class GetSeriesInitial extends GetSeriesState {}


final class GetSeriesLoading extends GetSeriesState {}
final class GetSeriesSuccess extends GetSeriesState {
final SeriesContentResponse seriesContentResponse;

  GetSeriesSuccess( this.seriesContentResponse);
}
final class GetSeriesFailuer extends GetSeriesState {
  final String errorMsg;

  GetSeriesFailuer( this.errorMsg);
}

