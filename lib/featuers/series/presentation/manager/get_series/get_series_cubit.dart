// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:iptv/featuers/series/data/models/series_model.dart';
import 'package:iptv/featuers/series/data/repos/series_repo/series_repo_impl.dart';
import 'package:meta/meta.dart';

part 'get_series_state.dart';

class GetSeriesCubit extends Cubit<GetSeriesState> {
  GetSeriesCubit() : super(GetSeriesInitial());
  void getSeries(String categoryId , String playlistId) async {
    if (isClosed) return;
    emit(GetSeriesLoading());
    var response = await SeriesRepoImpl().getSeries (categoryId , playlistId);
    if (isClosed) return;
    response.fold((l) => emit(GetSeriesFailuer(l.message)), (r) => emit(GetSeriesSuccess(r)));
  }

}
