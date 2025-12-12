// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:iptv/core/models/favorite_item.dart';
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/services/favorite_service.dart';
import 'package:iptv/featuers/live_tv/presentation/views/tv_player_view.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movie_stream/get_movie_stream_cubit.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movies/get_movies_cubit.dart';
import 'package:iptv/featuers/movies/presentation/views/widgets/movie_card.dart';
import 'package:iptv/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MoviesGrid extends StatefulWidget {
  final String selectedCategory;
  final String? searchQuery;

  const MoviesGrid({
    super.key,
    required this.selectedCategory,
    this.searchQuery,
  });

  @override
  State<MoviesGrid> createState() => _MoviesGridState();
}

class _MoviesGridState extends State<MoviesGrid> {
  late final FavoriteService _favoriteService;
  final Map<String, bool> _favoriteStates = {};

  @override
  void initState() {
    super.initState();
    _favoriteService = FavoriteService(CacheHelper.instance);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoriteService.getFavoritesByType('movie');
    
    if (mounted) {
      setState(() {
        for (var fav in favorites) {
          _favoriteStates[fav.id] = true;
        }
      });
    }
  }

  Future<void> _toggleFavorite(String id, String name, String imageUrl, String streamUrl, String ?originalUrl) async {
    
    
    final favoriteItem = FavoriteItem(
      id: id,
      name: name,
      originalUrl: originalUrl,
      imageUrl: imageUrl,
      streamUrl: streamUrl,
      type: 'movie',
      addedAt: DateTime.now(),
    );

    final result = await _favoriteService.toggleFavorite(favoriteItem);
    
    final isFav = await _favoriteService.isFavorite(id, 'movie');
    
    // Verify by getting all favorites
    final allFavs = await _favoriteService.getFavorites();
    if (allFavs.isNotEmpty) {
      for (var fav in allFavs) {
      }
    }
    
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
    return BlocBuilder<GetMoviesCubit, GetMoviesState>(
      builder: (context, state) {
        if (state is GetMoviesLoading ||
            state is GetMoviesError ||
            state is GetMoviesInitial) {
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
                return MovieCard(
                  title: 'Loading...',
                  imageUrl:
                      'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQYq7Mk3_qT905pUYNwN5JfQjLJoNx6n5iqB2M9iJ5MffZmKLPklzmAUJVs7P2VgVS5gspq3Q',
                );
              },
            ),
          );
        }

        if (state is GetMoviesSuccess) {
          var items = state.moviesContentResponse.content;
          final q = (widget.searchQuery ?? '').toLowerCase();
          if (q.isNotEmpty) {
            items = items
                .where((m) => m.name.toLowerCase().contains(q))
                .toList();
          }
          if (q.isNotEmpty && items.isEmpty) {
            return  Center(
              child: Text(S.current.no_movies, style: TextStyle(color: Colors.white)),
            );
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final movie = items[index];
              final isFavorite = _favoriteStates[movie.id] ?? false;
              
              return Stack(
                children: [
                  InkWell(
                    onTap: () async {
                      String url = movie.streamUrl;
                      if (url.contains('.mp4')) {

                        g.Get.to(
                          () => TvPlayerView(
                            isLive: false,
                            channelName: movie.name,
                            streamUrl: url,
                            imageUrl: movie.icon,
                            id: movie.id,
                            type: 'movie',
                          ),
                          transition: g.Transition.fade,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else {
                        String url;
                        if(movie.streamUrl.contains('.mkv')){
                          url = movie.originalUrl!;
                        }else{
                          url = movie.streamUrl;
                        }
                        BlocProvider.of<GetMovieStreamCubit>(
                          context,
                        ).getMovieStream(url , movie.icon, movie.name, id: movie.id, type: 'movie') ;
                      }
                    },
                    child: MovieCard(
                      title: movie.name,
                      imageUrl: movie.icon,
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
                            movie.id,
                            movie.name,
                            movie.icon,
                            movie.streamUrl,
                            movie.originalUrl,
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
              return MovieCard(
                title: S.current.loading,
                imageUrl:
                    'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQYq7Mk3_qT905pUYNwN5JfQjLJoNx6n5iqB2M9iJ5MffZmKLPklzmAUJVs7P2VgVS5gspq3Q',
              );
            },
          ),
        );
      },
    );
  }
}
