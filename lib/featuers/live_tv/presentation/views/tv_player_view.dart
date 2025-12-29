// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptv/core/models/history_item.dart';
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/services/history_service.dart';
import 'package:iptv/featuers/live_tv/presentation/views/widgets/tv_player_view_body.dart';

class TvPlayerView extends StatefulWidget {
  final String channelName;
  final String? streamUrl;
  final bool isLive;
  final String? imageUrl;
  final String? id;
  final String? type;

  // For episodes
  final String? seriesId;
  final String? seriesName;
  final String? episodeId;

  // For live TV
  final String? channelId;
  final String? channelIcon;

  final String? categoryId;

  const TvPlayerView({
    super.key,
    required this.channelName,
    this.streamUrl,
    this.isLive = false,
    this.imageUrl,
    this.id,
    this.type,
    this.seriesId,
    this.seriesName,
    this.channelIcon,

    this.episodeId,
    this.channelId,
    this.categoryId,
  });

  @override
  State<TvPlayerView> createState() => _TvPlayerViewState();
}

class _TvPlayerViewState extends State<TvPlayerView> {
  late final HistoryService _historyService;
  DateTime? _startWatchTime;

  @override
  void initState() {
    super.initState();
    _historyService = HistoryService(CacheHelper.instance);
    _startWatchTime = DateTime.now();
    _addToHistory();
    // TV-SAFE: Force landscape orientation with error handling
    _setLandscapeOrientation();
  }

  void _setLandscapeOrientation() {
    try {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('⚠️ Failed to set landscape orientation: $e');
    }

    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {
      debugPrint('⚠️ Failed to set immersive mode: $e');
      try {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      } catch (e2) {
        debugPrint('⚠️ All system UI modes failed: $e2');
      }
    }
  }

  @override
  void dispose() {
    // TV-SAFE: Ensure landscape orientation with error handling
    try {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('⚠️ Failed to maintain landscape in dispose: $e');
    }

    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {
      debugPrint('⚠️ Failed to maintain immersive mode in dispose: $e');
    }
    super.dispose();
  }

  Future<void> _addToHistory() async {
    if (widget.streamUrl == null || widget.streamUrl!.isEmpty) return;

    final historyItem = HistoryItem(
      id: widget.id ?? widget.streamUrl!,
      name: widget.channelName,
      imageUrl: widget.imageUrl ?? '',
      streamUrl: widget.streamUrl!,
      type: widget.type ?? (widget.isLive ? 'live_tv' : 'movie'),
      watchedAt: DateTime.now(),
      seriesId: widget.seriesId,
      episodeId: widget.episodeId,
      channelIcon: widget.channelIcon,
      seriesName: widget.seriesName,
      channelId: widget.channelId,
      categoryId: widget.categoryId,
    );

    await _historyService.addToHistory(historyItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TvPlayerViewBody(
        channelName: widget.channelName,
        streamUrl: widget.streamUrl,
        isLive: widget.isLive,
      ),
    );
  }
}
