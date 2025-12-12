part of 'get_series_categories_cubit.dart';

@immutable
sealed class GetSeriesCategoriesState {}

final class GetSeriesCategoriesInitial extends GetSeriesCategoriesState {}

final class GetSeriesCategoriesLoading extends GetSeriesCategoriesState {}

final class GetSeriesCategoriesSuccess extends GetSeriesCategoriesState {
  final SeriesCategoriesModel seriesCategoriesModel;
  GetSeriesCategoriesSuccess(this.seriesCategoriesModel);
}

final class GetSeriesCategoriesError extends GetSeriesCategoriesState {
  final String error;
  GetSeriesCategoriesError(this.error);
}
