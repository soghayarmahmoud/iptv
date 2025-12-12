import 'package:flutter/material.dart';
import 'package:iptv/featuers/live_tv/presentation/views/widgets/live_tv_view_body.dart';

class LiveTvView extends StatelessWidget {
  const LiveTvView({super.key, required this.playlistId});
  
  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiveTvViewBody(playlistId: playlistId),
    );
  }
}