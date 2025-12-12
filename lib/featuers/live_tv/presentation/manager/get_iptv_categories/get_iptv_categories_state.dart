part of 'get_iptv_categories_cubit.dart';

@immutable
sealed class GetIptvCategoriesState {}

final class GetIptvCategoriesInitial extends GetIptvCategoriesState {}

final class GetIptvCategoriesLoading extends GetIptvCategoriesState {}

final class GetIptvCategoriesSuccess extends GetIptvCategoriesState {
  final IptvCategoriesResponse iptvCategoriesResponse;
  GetIptvCategoriesSuccess(this.iptvCategoriesResponse);
}

final class GetIptvCategoriesError extends GetIptvCategoriesState {
  final String error;
  GetIptvCategoriesError(this.error);
}