import 'package:dartz/dartz.dart';
import 'package:iptv/core/errors/exceptions.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/core/services/api/api_consumer.dart';
import 'package:iptv/core/services/api/endpoints.dart';
import 'package:iptv/core/services/secure_storage.dart';
import 'package:iptv/featuers/start/data/models/user_data_model.dart';
import 'package:iptv/featuers/start/data/repos/auth_repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final ApiConsumer apiConsumer;

  AuthRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failuer, UserDataModel>> login(
    String username,
    String password,
  ) async {
    try {
      var response = await apiConsumer.post(
        Endpoints.login,
        body: {'username': username, 'password': password},
      );
            await saveToken(response['access_token']);
            await saveCustomId(response['customer']['id']);
          //  await savePlaylistId(response['customer']['playlists'][3]['id']);

      return Right(UserDataModel.fromJson(response));
    } on ServerError catch (e) {
      return Left(Failuer(e.errorModel.errorMsg));
    } catch (e) {
      
      return Left(Failuer('An unknown error occurred'));
    }
  }
}
