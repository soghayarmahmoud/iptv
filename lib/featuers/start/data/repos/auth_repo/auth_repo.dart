import 'package:dartz/dartz.dart';
import 'package:iptv/core/errors/failuer.dart';
import 'package:iptv/featuers/start/data/models/user_data_model.dart';

abstract class AuthRepo {
  Future<Either<Failuer, UserDataModel>> login(String username, String password);
}