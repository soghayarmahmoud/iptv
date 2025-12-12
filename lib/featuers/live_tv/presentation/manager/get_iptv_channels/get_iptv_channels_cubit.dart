// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:iptv/featuers/live_tv/data/models/iptv_channel_model.dart';
import 'package:iptv/featuers/live_tv/data/repos/iptv_live_repo/iptv_live_repo_impl.dart';
import 'package:meta/meta.dart';

part 'get_iptv_channels_state.dart';

class GetIptvChannelsCubit extends Cubit<GetIptvChannelsState> {
  GetIptvChannelsCubit() : super(GetIptvChannelsInitial());
  void reset() {
    if (isClosed) return;
    emit(GetIptvChannelsInitial());
  }
  
  void setLoading() {
    if (isClosed) return;
    emit(GetIptvChannelsLoading());
  }
  
  void getIptvChannels(String categoryId , String playlistId) async {
    if (isClosed) return;
    emit(GetIptvChannelsLoading());
    
    var response = await IptvLiveRepoImpl().getIptvChannels(categoryId, playlistId);
    
    if (isClosed) return;
    response.fold(
      (l) => emit(GetIptvChannelsError(l.message)),
      (r) => emit(GetIptvChannelsSuccess(r)),
    );
  }
}
