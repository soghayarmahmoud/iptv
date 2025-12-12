// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:iptv/featuers/movies/data/repos/movies_repo/movies_repo_impl.dart';
import 'package:meta/meta.dart';

part 'get_movie_stream_state.dart';

class GetMovieStreamCubit extends Cubit<GetMovieStreamState> {
  GetMovieStreamCubit() : super(GetMovieStreamInitial());

  
  void getMovieStream(String? url , String imageUrl , String name, {String? id, String? type}) async {
    if (isClosed) return;
    emit(GetMovieStreamLoading());
    var response = await MoviesRepoImpl().getMovieConvertedUrlStream(url!);
    if (isClosed) return;
    response.fold(
      (l) {
        if (isClosed) return;
        emit(GetMovieStreamError(l.message));
      },
      (r) {
        if (isClosed) return;
        emit(GetMovieStreamSuccess(r , imageUrl, name, id: id, type: type) );
      },
    );
  }
}
