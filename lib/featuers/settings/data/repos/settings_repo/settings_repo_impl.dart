import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:iptv/core/errors/exceptions.dart';
import 'package:iptv/core/services/api/dio_consumer.dart';
import 'package:iptv/core/services/api/endpoints.dart';
import 'package:iptv/featuers/settings/data/repos/settings_repo/settings_repo.dart';

class SettingsRepoImpl implements SettingsRepo {
  @override
  Future<Either<String, String>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      var response = await DioConsumer(dio: Dio()).put(
        Endpoints.changePassword,
        body: {"currentPassword": oldPassword, "newPassword": newPassword},
      );
     if(response['success']){
      return right(response['message']);
     }
     else{
      return left(response['message']);
     }
    } on ServerError catch (e) {
      return left(e.errorModel.errorMsg);
    } catch (e) {
      return left('An unknown error occurred');
    }
  }
}
