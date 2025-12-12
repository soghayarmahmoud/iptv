import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:iptv/core/errors/exceptions.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/core/services/api/dio_consumer.dart';
import 'package:iptv/core/services/api/endpoints.dart';
import 'package:iptv/featuers/live_tv/data/models/iptv_channel_category_model.dart';
import 'package:iptv/featuers/live_tv/data/models/iptv_channel_model.dart';
import 'package:iptv/featuers/live_tv/data/repos/iptv_live_repo/iptv_live_repo.dart';

class IptvLiveRepoImpl extends IptvLiveRepo {
  @override
  Future<Either<Failuer, IptvCategoriesResponse>> getIptvCategories(String playlistId) async {
    try {
     
      final response = await DioConsumer(dio: Dio()).get(Endpoints.getIptvCategories(playlistId));
     
      return Right(IptvCategoriesResponse.fromJson(response));
    } on ServerError catch (e) {

      return Left(Failuer(e.errorModel.errorMsg));
      
    } catch (e) {
     
      return Left(Failuer('An unknown error occurred'));
    }
  }

  @override
  Future<Either<Failuer, IptvChannelsResponse>> getIptvChannels(String categoryId , String playlistId) async {
    try {
    
      final response = await DioConsumer(dio: Dio()).get(Endpoints.getIptvChannels(categoryId, playlistId));
      return Right(IptvChannelsResponse.fromJson(response));
    } on ServerError catch (e) {
      return Left(Failuer(e.errorModel.errorMsg));
    } catch (e) {
      return Left(Failuer('An unknown error occurred'));
    }
  }
}