// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:iptv/featuers/settings/data/repos/settings_repo/settings_repo.dart';
import 'package:iptv/featuers/settings/data/repos/settings_repo/settings_repo_impl.dart';
import 'package:meta/meta.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  final SettingsRepo settingsRepo = SettingsRepoImpl();
  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(ChangePasswordLoading());
    var response = await settingsRepo.changePassword(oldPassword, newPassword);
    response.fold((l) => emit(ChangePasswordError(l)), (r) => emit(ChangePasswordSuccess(r)));
  }
}
