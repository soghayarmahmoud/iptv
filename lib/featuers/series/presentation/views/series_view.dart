import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/featuers/series/presentation/manager/get_series/get_series_cubit.dart';
import 'package:iptv/featuers/series/presentation/manager/get_series_categories/get_series_categories_cubit.dart';
import 'package:iptv/featuers/series/presentation/views/widgets/series_view_body.dart';

class SeriesView extends StatelessWidget {
  const SeriesView({super.key, required this.playlistId});
  
  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetSeriesCategoriesCubit()),
        BlocProvider(create: (context) => GetSeriesCubit()),
      ],
      child: Scaffold(body: SeriesViewBody(playlistId: playlistId)),
    );
  }
}
