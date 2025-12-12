import 'package:dartz/dartz.dart';

abstract class SettingsRepo {
  Future<Either<String , String>> changePassword(String  oldPassword , String newPassword);
}