// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:iptv/featuers/series/data/models/series_categories_model.dart';
import 'package:iptv/featuers/series/data/repos/series_repo/series_repo_impl.dart';
import 'package:meta/meta.dart';

part 'get_series_categories_state.dart';

class GetSeriesCategoriesCubit extends Cubit<GetSeriesCategoriesState> {
  GetSeriesCategoriesCubit() : super(GetSeriesCategoriesInitial());

  void getSeriesCategories(String playlistId) async {
    if (isClosed) return;
    emit(GetSeriesCategoriesLoading());
    
    var response = await SeriesRepoImpl().getSeriesCategories(playlistId);
    
    if (isClosed) return;
    response.fold(
      (l) => emit(GetSeriesCategoriesError(l.message)),
      (r) => emit(GetSeriesCategoriesSuccess(r)),
    );
  }
}
