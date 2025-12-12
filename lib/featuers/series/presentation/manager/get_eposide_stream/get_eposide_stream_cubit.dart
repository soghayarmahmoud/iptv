// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:iptv/featuers/series/data/models/eposide_stream_model.dart';
import 'package:iptv/featuers/series/data/repos/series_repo/series_repo_impl.dart';
import 'package:meta/meta.dart';

part 'get_eposide_stream_state.dart';

class GetEposideStreamCubit extends Cubit<GetEposideStreamState> {
  GetEposideStreamCubit() : super(GetEposideStreamInitial());

  void getEposideStream(String seriesId, String eposideId , String playlistId) async {
    if (isClosed) return;
    emit(GetEposideStreamLoading());
    var response = await SeriesRepoImpl().getEposideStream(seriesId, eposideId , playlistId);
    if (isClosed) return;
    response.fold(
      (l) {
        if (isClosed) return;
        emit(GetEposideStreamError(l.message));
      },
      (r) {
        if (isClosed) return;
        emit(GetEposideStreamSuccess(r));
      },
    );
  }
}
