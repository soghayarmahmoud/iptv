// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart' as g;
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/featuers/live_tv/presentation/views/live_tv_view.dart';
import 'package:iptv/featuers/movies/presentation/views/movies_view.dart';
import 'package:iptv/featuers/playlists/data/models/playlist_model.dart';
import 'package:iptv/featuers/series/presentation/views/series_view.dart';

class ListViewOfPlaylists extends StatelessWidget {
  const ListViewOfPlaylists({
    super.key,
    required this.playlists,
    required this.live,
    required this.movies,
    required this.series,
  });
  final List<PlaylistModel> playlists;
  final bool live, movies, series;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170, // Adjust this height as appropriate for your UI
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (live) {
                g.Get.to(
                  () => LiveTvView(playlistId: playlists[index].id),
                  transition: g.Transition.fade,
                  duration: const Duration(milliseconds: 400),
                );
              }
              if (movies) {
                g.Get.to(
                  () => MoviesView(playlistId: playlists[index].id),
                  transition: g.Transition.fade,
                  duration: const Duration(milliseconds: 400),
                );
              }
              if (series) {
                g.Get.to(
                  () => SeriesView(playlistId: playlists[index].id),
                  transition: g.Transition.fade,
                  duration: const Duration(milliseconds: 400),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: 140,
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white.withOpacity(0.10),
                          border: Border.all(color: Colors.white.withOpacity(0.22)),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Text(
                                  '#${index + 1}',
                                  style: TextStyles.font14Medium(context).copyWith(color: AppColors.whiteColor),
                                ),
                              ),
                            ),
                            Center(
                              child: Icon(
                                Icons.playlist_play,
                                color: AppColors.yellowColor,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    playlists[index].name,
                    style: TextStyles.font14Medium(
                      context,
                    ).copyWith(color: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
