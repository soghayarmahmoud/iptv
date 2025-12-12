import 'package:dartz/dartz.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/featuers/live_tv/data/models/iptv_channel_category_model.dart';
import 'package:iptv/featuers/live_tv/data/models/iptv_channel_model.dart';

abstract class IptvLiveRepo {
  Future<Either<Failuer, IptvCategoriesResponse>> getIptvCategories(String playlistId);
  Future<Either<Failuer, IptvChannelsResponse>> getIptvChannels(String categoryId , String playlistId);
}