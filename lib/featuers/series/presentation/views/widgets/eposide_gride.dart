// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/widgets/snack_bars/custom_snack_bar.dart';
import 'package:iptv/featuers/live_tv/presentation/views/tv_player_view.dart';
import 'package:iptv/featuers/series/data/models/eposide_model.dart';
import 'package:iptv/featuers/series/presentation/manager/get_eposide_stream/get_eposide_stream_cubit.dart';
import 'package:iptv/featuers/series/presentation/manager/get_eposides/get_eposides_cubit.dart';
import 'package:iptv/featuers/movies/presentation/views/widgets/movie_card.dart';
import 'package:iptv/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EposideGrid extends StatefulWidget {
  final String searchQuery;
  final String seriesId;
  final String playlistId;

  const EposideGrid({
    super.key,
    required this.searchQuery,
    required this.seriesId,
    required this.playlistId,
  });

  @override
  State<EposideGrid> createState() => _EposideGridState();
}

class _EposideGridState extends State<EposideGrid> {
  int _calculateCrossAxisCount(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= 1600) return 6;
    if (width >= 1300) return 5;
    if (width >= 1000) return 4;
    if (width >= 700) return 3;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = _calculateCrossAxisCount(context);

    return BlocBuilder<GetEposidesCubit, GetEposidesState>(
      builder: (context, state) {
        if (state is GetEposidesLoading) {
          return Skeletonizer(
            effect: ShimmerEffect(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              duration: const Duration(seconds: 1),
            ),
            enabled: true,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return const MovieCard(title: 'Loading...', imageUrl: '');
              },
            ),
          );
        }

        if (state is GetEposidesError) {
          return Center(
            child: Text(
              state.error,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (state is GetEposidesSuccess) {
          // Flatten episodes across all seasons for now
          final Map<String, List<Episode>> episodesBySeason =
              state.seriesDetailResponse.series.episodesBySeason;
          List<Episode> items = episodesBySeason.values
              .expand((e) => e)
              .toList();
          if (widget.searchQuery.trim().isNotEmpty) {
            final String q = widget.searchQuery.toLowerCase();
            items = items
                .where((e) => e.title.toLowerCase().contains(q))
                .toList();
          }

          if (widget.searchQuery.isNotEmpty && items.isEmpty) {
            return Center(
              child: Text(
                S.current.no_episode,
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return BlocListener<GetEposideStreamCubit, GetEposideStreamState>(
            listener: (context, stateOfGetEposides) {
              if (stateOfGetEposides is GetEposideStreamLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.yellowColor,
                    ),
                  ),
                );
              }

              if (stateOfGetEposides is GetEposideStreamSuccess) {
                // Close any open dialogs first
                Navigator.of(context).pop();

                g.Get.to(
                  () => TvPlayerView(
                    isLive: false,
                    imageUrl: state.seriesDetailResponse.series.info.cover,
                    channelName: state.seriesDetailResponse.series.info.name,
                    streamUrl: stateOfGetEposides
                        .episodeStreamResponse
                        .episode
                        .streamUrl,
                    id: stateOfGetEposides.episodeStreamResponse.episode.id,
                    type: 'episode',
                  ),
                  transition: g.Transition.fade,
                  duration: const Duration(milliseconds: 300),
                );
              }

              if (stateOfGetEposides is GetEposideStreamError) {
                // Close any open dialogs first
                Navigator.of(context).pop();

                CustomSnackBar().showCustomSnackBar(
                  context: context,
                  message: 'An error occurred',
                  type: SnackBarType.error,
                );
              }
            },
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final Episode item = items[index];
                final String title = item.title.isNotEmpty
                    ? item.title
                    : 'Episode ${item.episodeNum}';
                // Use series cover as a placeholder image; episodes may not have images
                final String imageUrl =
                    state.seriesDetailResponse.series.info.cover.isNotEmpty
                    ? state.seriesDetailResponse.series.info.cover
                    : 'https://via.placeholder.com/300x450.png?text=No+Image';
                return InkWell(
                  onTap: () {
                    context.read<GetEposideStreamCubit>().getEposideStream(
                      widget.seriesId,
                      item.id,
                      widget.playlistId,
                    );
                  },
                  child: MovieCard(title: title, imageUrl: imageUrl),
                );
              },
            ),
          );
        }

        return Skeletonizer(
          effect: ShimmerEffect(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            duration: const Duration(seconds: 1),
          ),
          enabled: true,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return MovieCard(title: S.current.loading, imageUrl: '');
            },
          ),
        );
      },
    );
  }
}
