import 'package:flutter/material.dart';
import 'package:iptv/featuers/live_tv/presentation/views/widgets/media_tv_player_view_body.dart';


class MediaTvPlayerView extends StatelessWidget {
  final String channelName;
  final String? streamUrl;
  final bool isLive;

  const MediaTvPlayerView({super.key, required this.channelName, this.streamUrl, this.isLive = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaTvPlayerViewBody(channelName: channelName, streamUrl: streamUrl, isLive: isLive),
    );
  }
}