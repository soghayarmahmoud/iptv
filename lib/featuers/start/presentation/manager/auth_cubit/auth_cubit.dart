import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:iptv/core/services/api/dio_consumer.dart';
import 'package:iptv/featuers/start/data/models/user_data_model.dart';
import 'package:iptv/featuers/start/data/repos/auth_repo/auth_repo.dart';
import 'package:iptv/featuers/start/data/repos/auth_repo/auth_repo_impl.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final AuthRepo authRepo = AuthRepoImpl(apiConsumer: DioConsumer(dio: Dio()));

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    final response = await authRepo.login(username, password);
    response.fold((l) => emit(AuthError(l.message)), (r) => emit(AuthSuccess(r)));
  }
}
