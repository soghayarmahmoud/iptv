// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:iptv/featuers/series/data/models/eposide_model.dart';
import 'package:iptv/featuers/series/data/repos/series_repo/series_repo_impl.dart';
import 'package:meta/meta.dart';

part 'get_eposides_state.dart';

class GetEposidesCubit extends Cubit<GetEposidesState> {
  GetEposidesCubit() : super(GetEposidesInitial());
  void getEposides(String seriesId , String playlistId) async {
    if (isClosed) return;
    emit(GetEposidesLoading());
    var response = await SeriesRepoImpl().getEposides(seriesId , playlistId);
    if (isClosed) return;
    response.fold(
      (l) {
        if (isClosed) return;
        emit(GetEposidesError(l.message));
      },
      (r) {
        if (isClosed) return;
        emit(GetEposidesSuccess(r));
      },
    );
  }
}
