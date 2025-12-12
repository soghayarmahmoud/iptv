// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_images.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool showFavoriteButton;
  final bool isFavorite;
  
  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.showFavoriteButton = false,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryColorTheme,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                    placeholder: (context, url) => Skeletonizer(
                      effect: ShimmerEffect(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        duration: const Duration(seconds: 1),
                      ),
                      enabled: true,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          Assets.imagesLogo,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipRRect(
                      child: Skeletonizer(
                        effect: ShimmerEffect(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          duration: const Duration(seconds: 1),
                        ),
                        enabled: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            Assets.imagesLogo,
                          ),
                        ),
                      ),
                    ),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl:
                        imageUrl,
                  ),
                ),
            ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.secondaryColorTheme,
                  AppColors.secondaryColorTheme.withOpacity(.4),
                ],
              ),
            ),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font14Medium(
                context,
              ).copyWith(color: AppColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}
