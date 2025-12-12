// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:iptv/core/models/history_item.dart';
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/services/history_service.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/featuers/live_tv/presentation/views/tv_player_view.dart';
import 'package:iptv/featuers/movies/presentation/views/widgets/movie_card.dart';
import 'package:iptv/generated/l10n.dart';
import 'package:intl/intl.dart';

class HistoryViewBody extends StatefulWidget {
  const HistoryViewBody({super.key});

  @override
  State<HistoryViewBody> createState() => _HistoryViewBodyState();
}

class _HistoryViewBodyState extends State<HistoryViewBody> with SingleTickerProviderStateMixin {
  late final HistoryService _historyService;
  late TabController _tabController;
  List<HistoryItem> _allHistory = [];
  List<HistoryItem> _liveTvHistory = [];
  List<HistoryItem> _movieHistory = [];
  List<HistoryItem> _episodeHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _historyService = HistoryService(CacheHelper.instance);
    _tabController = TabController(length: 4, vsync: this);
    _loadHistory();

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    
    final history = await _historyService.getHistory();
    final liveTv = await _historyService.getHistoryByType('live_tv');
    final movies = await _historyService.getHistoryByType('movie');
    final episodes = await _historyService.getHistoryByType('episode');
    
    if (mounted) {
      setState(() {
        _allHistory = history;
        _liveTvHistory = liveTv;
        _movieHistory = movies;
        _episodeHistory = episodes;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeHistoryItem(HistoryItem item) async {
    await _historyService.removeFromHistory(item.id, item.type);
    _loadHistory();
  }

  Future<void> _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryColorTheme,
        title: Text(
          S.current.clear_history,
          style: TextStyles.font18SemiBold(context).copyWith(color: Colors.white),
        ),
        content: Text(
          S.current.confirm_clear_history,
          style: TextStyles.font14Regular(context).copyWith(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.current.cancel, style: TextStyles.font18SemiBold(context).copyWith(color:  Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.current.clear, style: TextStyles.font18SemiBold(context).copyWith(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _historyService.clearHistory();
      _loadHistory();
    }
  }

  void _playItem(HistoryItem item) {

    g.Get.to(
      () => TvPlayerView(
        channelName: item.name,
        streamUrl: item.streamUrl,
        imageUrl: item.type == 'live_tv' ? item.channelIcon : item.imageUrl,
        channelIcon: item.channelIcon,
        id: item.id,
        type: item.type,
        seriesId: item.seriesId,
        episodeId: item.episodeId,
        seriesName: item.seriesName,
        channelId: item.channelId,
        categoryId: item.categoryId,
        isLive: item.type == 'live_tv',
      ),
      transition: g.Transition.fade,
      duration: const Duration(milliseconds: 300),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (difference.inDays > 7) {
      return DateFormat('MMM d, y').format(dateTime);
    } else if (difference.inDays > 0) {
      return isArabic ? 'منذ ${difference.inDays} يوم' : '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return isArabic ? 'منذ ${difference.inHours} ساعة' : '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return isArabic ? 'منذ ${difference.inMinutes} دقيقة' : '${difference.inMinutes}m ago';
    } else {
      return isArabic ? 'الآن' : 'Just now';
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
                      S.current.history,
                      style: TextStyles.font22ExtraBold(context)
                          .copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                 
                  if (_allHistory.isNotEmpty) const SizedBox(width: 16),
                  if (_allHistory.isNotEmpty)
                    InkWell(
                      onTap: _clearAllHistory,
                      child: Icon(
                        Icons.delete_sweep,
                        color: Colors.red,
                        size: 28,
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
                  Tab(text: '${S.current.All} (${_allHistory.length})'),
                  Tab(text: '${S.current.live_tv} (${_liveTvHistory.length})'),
                  Tab(text: '${S.current.Movies} (${_movieHistory.length})'),
                  Tab(text: '${S.current.Series} (${_episodeHistory.length})'),
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
                        _buildHistoryList(_allHistory),
                        _buildHistoryList(_liveTvHistory),
                        _buildHistoryList(_movieHistory),
                        _buildHistoryList(_episodeHistory),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<HistoryItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: AppColors.whiteColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              S.current.no_history,
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
            onTap: () => _playItem(item),
            child: Stack(
              children: [
                MovieCard(
                  title: item.type == 'episode'
                      ? '${item.seriesName ?? ""} - ${item.name}'
                      : item.name,
                  imageUrl: item.type == 'live_tv' ? item.channelIcon ?? '' : item.imageUrl,
                ),
                // Delete button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _removeHistoryItem(item),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Type badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.type == 'live_tv'
                          ? Colors.red
                          : item.type == 'movie'
                              ? AppColors.yellowColor
                              : Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.type == 'live_tv'
                          ? 'LIVE'
                          : item.type == 'movie'
                              ? 'Movie'
                              : 'Episode',
                      style: TextStyles.font12Medium(context)
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                // Watched time
                Positioned(
                  bottom: 50,
                  left: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white70,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _getTimeAgo(item.watchedAt),
                            style: TextStyles.font11Regular(context)
                                .copyWith(color: Colors.white70),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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