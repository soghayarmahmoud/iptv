// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:iptv/featuers/live_tv/data/models/iptv_channel_category_model.dart';
import 'package:iptv/featuers/live_tv/data/repos/iptv_live_repo/iptv_live_repo_impl.dart';
import 'package:meta/meta.dart';

part 'get_iptv_categories_state.dart';

class GetIptvCategoriesCubit extends Cubit<GetIptvCategoriesState> {
  GetIptvCategoriesCubit() : super(GetIptvCategoriesInitial());

  void getIptvCategories(String playlistId) async {
    if (isClosed) return;
    emit(GetIptvCategoriesLoading());
    
    var response = await IptvLiveRepoImpl().getIptvCategories(playlistId);
    
    if (isClosed) return;
    response.fold(
      (l) => emit(GetIptvCategoriesError(l.message)),
      (r) => emit(GetIptvCategoriesSuccess(r)),
    );
  }
}
