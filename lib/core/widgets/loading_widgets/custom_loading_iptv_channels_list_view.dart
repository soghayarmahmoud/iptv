// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomLoadingIptvChannelsListView extends StatelessWidget {
  const CustomLoadingIptvChannelsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return    Skeletonizer(
                            effect: ShimmerEffect(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              duration: const Duration(seconds: 1),
                            ),
                            enabled: true,
                            child: ListView.separated(
                              itemCount: 10,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.image,
                                          color: Colors.white24,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        '${index + 1}',
                                        style: TextStyles.font20Medium(
                                          context,
                                        ).copyWith(color: AppColors.whiteColor),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Channel ${index + 1}',
                                          style:
                                              TextStyles.font20Medium(
                                                context,
                                              ).copyWith(
                                                color: AppColors.whiteColor,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
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