import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/featuers/series/presentation/manager/get_eposide_stream/get_eposide_stream_cubit.dart';
import 'package:iptv/featuers/series/presentation/manager/get_eposides/get_eposides_cubit.dart';
import 'package:iptv/featuers/series/presentation/views/widgets/eposides_view_body.dart';

class EposidesView extends StatelessWidget {
  final String seriesId;
  const EposidesView({super.key, required this.seriesId, required this.playlistId});
  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetEposidesCubit()..getEposides(seriesId, playlistId),
        ),
        BlocProvider(create: (context) => GetEposideStreamCubit()),
      ],
      child: Scaffold(body: EposidesViewBody(seriesId: seriesId, playlistId: playlistId)),
    );
  }
}
