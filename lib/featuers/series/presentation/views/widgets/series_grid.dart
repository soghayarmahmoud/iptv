// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/core/models/favorite_item.dart';
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/services/favorite_service.dart';
import 'package:iptv/featuers/series/data/models/series_model.dart';
import 'package:iptv/featuers/series/presentation/manager/get_series/get_series_cubit.dart';
import 'package:iptv/featuers/movies/presentation/views/widgets/movie_card.dart';
import 'package:iptv/featuers/series/presentation/views/eposides_view.dart';
import 'package:iptv/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SeriesGrid extends StatefulWidget {
  final String selectedCategory;
  final String searchQuery;
  final String playlistId;

  const SeriesGrid({
    super.key,
    required this.selectedCategory,
    required this.searchQuery,
    required this.playlistId,
  });

  @override
  State<SeriesGrid> createState() => _SeriesGridState();
}

class _SeriesGridState extends State<SeriesGrid> {
  late final FavoriteService _favoriteService;
  final Map<String, bool> _favoriteStates = {};

  @override
  void initState() {
    super.initState();
    _favoriteService = FavoriteService(CacheHelper.instance);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoriteService.getFavoritesByType('series');
    
    if (mounted) {
      setState(() {
        for (var fav in favorites) {
          _favoriteStates[fav.id] = true;
        }
      });
    }
  }

  Future<void> _toggleFavorite(String id, String name, String imageUrl) async {
  
    
    final favoriteItem = FavoriteItem(
      id: id,
      name: name,
      imageUrl: imageUrl,
      streamUrl: '', // Series don't have direct stream URLs
      type: 'series',
      addedAt: DateTime.now(),
      seriesId: id,
      seriesName: name,
    );

    await _favoriteService.toggleFavorite(favoriteItem);
    final isFav = await _favoriteService.isFavorite(id, 'series');
    
    if (mounted) {
      setState(() {
        _favoriteStates[id] = isFav;
      });
    }
  }

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

    return BlocBuilder<GetSeriesCubit, GetSeriesState>(
      builder: (context, state) {
        if (state is GetSeriesLoading) {
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

        if (state is GetSeriesFailuer) {
          return Center(child: Text(state.errorMsg, style: const TextStyle(color: Colors.white)));
        }

        if (state is GetSeriesSuccess) {
          List<SeriesItem> items = state.seriesContentResponse.content;
          if (widget.searchQuery.trim().isNotEmpty) {
            final String q = widget.searchQuery.toLowerCase();
            items = items.where((e) => e.name.toLowerCase().contains(q)).toList();
          }

         if (widget.searchQuery.isNotEmpty && items.isEmpty) {
            return  Center(
              child: Text(
                S.current.no_series,
                style: TextStyle(color: Colors.white),
              ),
            );}
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final SeriesItem item = items[index];
              final isFavorite = _favoriteStates[item.id] ?? false;
              final String title = item.name;
              final String imageUrl = item.icon.isNotEmpty ? item.icon : 'https://via.placeholder.com/300x450.png?text=No+Image';
              
              return Stack(
                children: [
                  InkWell(
                    onTap: () {
                      g.Get.to(
                        () => EposidesView(seriesId: item.id , playlistId: widget.playlistId),
                        transition: g.Transition.fade,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                    child: MovieCard(
                      title: title,
                      imageUrl: imageUrl,
                      showFavoriteButton: false,
                      isFavorite: isFavorite,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _toggleFavorite(
                            item.id,
                            item.name,
                            imageUrl,
                          );
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
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
