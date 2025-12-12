// ignore_for_file: deprecated_member_use, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:iptv/core/models/favorite_item.dart';
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/services/favorite_service.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/featuers/live_tv/presentation/views/tv_player_view.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movie_stream/get_movie_stream_cubit.dart';
import 'package:iptv/featuers/movies/presentation/views/widgets/movie_card.dart';
import 'package:iptv/generated/l10n.dart';

class FavShowViewsBody extends StatefulWidget {
  const FavShowViewsBody({super.key});

  @override
  State<FavShowViewsBody> createState() => _FavShowViewsBodyState();
}

class _FavShowViewsBodyState extends State<FavShowViewsBody> with SingleTickerProviderStateMixin {
  late final FavoriteService _favoriteService;
  late TabController _tabController;
  List<FavoriteItem> _allFavorites = [];
  List<FavoriteItem> _movieFavorites = [];
  List<FavoriteItem> _seriesFavorites = [];
  List<FavoriteItem> _liveTvFavorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _favoriteService = FavoriteService(CacheHelper.instance);
    _tabController = TabController(length: 4, vsync: this);
    _loadFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    
    final favorites = await _favoriteService.getFavorites();
    final movies = await _favoriteService.getFavoritesByType('movie');
    final series = await _favoriteService.getFavoritesByType('series');
    final liveTv = await _favoriteService.getFavoritesByType('live_tv');
    
    if (mounted) {
      setState(() {
        _allFavorites = favorites;
        _movieFavorites = movies;
        _seriesFavorites = series;
        _liveTvFavorites = liveTv;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(FavoriteItem item) async {
    await _favoriteService.removeFromFavorites(item.id, item.type);
    _loadFavorites();
  }

  void _playItem(FavoriteItem item) {

    if(item.streamUrl.contains('.mp4')){
       g.Get.to(
              () => TvPlayerView(
                isLive: false,
                imageUrl: item.type == 'live_tv' ? item.channelIcon : item.imageUrl,
                channelName: item.name,
                streamUrl: item.streamUrl,
                id: item.id,
                channelIcon: item.channelIcon,
                
                type: item.type,
              ),
              transition: g.Transition.fade,
              duration: const Duration(milliseconds: 300),
            );
    }else{
    String url;
    if(item.streamUrl.contains('.mkv')){
      url = item.originalUrl!;
    }else{
      url = item.streamUrl;
    }
    BlocProvider.of<GetMovieStreamCubit>(
      context,
    ).getMovieStream(url , item.imageUrl, item.name, id: item.id, type: item.type);
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondaryColorTheme, AppColors.mainColorTheme],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      S.current.favorite,
                      style: TextStyles.font22ExtraBold(context)
                          .copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.secondaryColorTheme.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.yellowColor,
                indicatorWeight: 3,
                labelColor: AppColors.whiteColor,
                unselectedLabelColor: AppColors.whiteColor.withOpacity(0.5),
                labelStyle: TextStyles.font14SemiBold(context),
                tabs: [
                  Tab(text: '${S.current.All} (${_allFavorites.length})'),
                                    Tab(text: '${S.current.live_tv} (${_liveTvFavorites.length})'),

                  Tab(text: '${S.current.Movies} (${_movieFavorites.length})'),
                  Tab(text: '${S.current.Series} (${_seriesFavorites.length})'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.yellowColor,
                      ),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildFavoritesList(_allFavorites),
                                                _buildFavoritesList(_liveTvFavorites),

                        _buildFavoritesList(_movieFavorites),
                        _buildFavoritesList(_seriesFavorites),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(List<FavoriteItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppColors.whiteColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              S.current.no_favorites,
              style: TextStyles.font18SemiBold(context)
                  .copyWith(color: AppColors.whiteColor.withOpacity(0.6)),
            ),
          ],
        ),
      );
    }

    final int crossAxisCount = _calculateCrossAxisCount(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            onTap: () {
              if (item.type == 'series') {
                // Navigate to series episodes view
                // You'll need to import and navigate to the episodes view
                // For now, we'll just skip playback for series
              } else if (item.type == 'live_tv' && item.streamUrl.isNotEmpty) {
                // Play live TV channel
                g.Get.to(
                  () => TvPlayerView(
                    channelName: item.name,
                    streamUrl: item.streamUrl,
                    imageUrl: item.imageUrl,
                    channelIcon: item.imageUrl, // Pass as channelIcon for history tracking
                    id: item.id,
                    type: 'live_tv',
                    isLive: true,
                  ),
                  transition: g.Transition.fade,
                  duration: const Duration(milliseconds: 300),
                );
              } else if (item.streamUrl.isNotEmpty) {
                _playItem(item);
              }
            },
            child: Stack(
              children: [
                MovieCard(
                  title: item.type == 'series'
                      ? item.name
                      : item.name,
                  imageUrl: item.imageUrl,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _removeFavorite(item),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.type == 'movie'
                          ? AppColors.yellowColor
                          : item.type == 'series'
                              ? Colors.purple
                              : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.type == 'movie' 
                          ? 'Movie' 
                          : item.type == 'series' 
                              ? 'Series' 
                              : 'Live TV',
                      style: TextStyles.font12Medium(context)
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}