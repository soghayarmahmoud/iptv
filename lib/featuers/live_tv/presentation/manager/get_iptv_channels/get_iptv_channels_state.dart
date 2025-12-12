part of 'get_iptv_channels_cubit.dart';

@immutable
sealed class GetIptvChannelsState {}

final class GetIptvChannelsInitial extends GetIptvChannelsState {}

final class GetIptvChannelsLoading extends GetIptvChannelsState {}

final class GetIptvChannelsSuccess extends GetIptvChannelsState {
  final IptvChannelsResponse iptvChannelsResponse;
  GetIptvChannelsSuccess(this.iptvChannelsResponse);
}

final class GetIptvChannelsError extends GetIptvChannelsState {
  final String error;
  GetIptvChannelsError(this.error);
}