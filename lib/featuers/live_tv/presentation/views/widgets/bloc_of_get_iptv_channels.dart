// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:iptv/core/models/favorite_item.dart';
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/services/favorite_service.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_images.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/core/widgets/loading_widgets/custom_loading_iptv_channels_list_view.dart';
import 'package:iptv/featuers/live_tv/data/models/iptv_channel_model.dart';
import 'package:iptv/featuers/live_tv/presentation/manager/get_iptv_channels/get_iptv_channels_cubit.dart';
import 'package:iptv/featuers/live_tv/presentation/views/tv_player_view.dart';
import 'package:iptv/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BlocOfGetIptvChannels extends StatefulWidget {
  const BlocOfGetIptvChannels({super.key});

  @override
  State<BlocOfGetIptvChannels> createState() => _BlocOfGetIptvChannelsState();
}

class _BlocOfGetIptvChannelsState extends State<BlocOfGetIptvChannels> {
  int _selectedChannel = 0;
  late final FavoriteService _favoriteService;
  final Map<String, bool> _favoriteStates = {};

  @override
  void initState() {
    super.initState();
    _favoriteService = FavoriteService(CacheHelper.instance);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoriteService.getFavoritesByType('live_tv');
    
    if (mounted) {
      setState(() {
        for (var fav in favorites) {
          _favoriteStates[fav.id] = true;
        }
      });
    }
  }

  Future<void> _toggleFavorite(
    String id,
    String name,
    String imageUrl,
    String streamUrl,
  ) async {
   
    final favoriteItem = FavoriteItem(
      id: id,
      name: name,
      imageUrl: imageUrl,
      streamUrl: streamUrl,
      type: 'live_tv',
      addedAt: DateTime.now(),
    );

    await _favoriteService.toggleFavorite(favoriteItem);
    final isFav = await _favoriteService.isFavorite(id, 'live_tv');
    
    
    if (mounted) {
      setState(() {
        _favoriteStates[id] = isFav;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Expanded(
                    child: BlocBuilder<GetIptvChannelsCubit, GetIptvChannelsState>(
                      builder: (context, state) {
                        if (state is GetIptvChannelsLoading || state is GetIptvChannelsError) {
                       return CustomLoadingIptvChannelsListView();
                        }
                       
                        if (state is GetIptvChannelsSuccess) {
                          final List<IptvChannel> channels =
                              state.iptvChannelsResponse.channels;
                          if (channels.isEmpty) {
                            return Center(
                              child: Text(
                                S.current.No_channels,
                                style: TextStyles.font18Medium(
                                  context,
                                ).copyWith(color: AppColors.subGreyColor),
                              ),
                            );
                          }
                          if (_selectedChannel >= channels.length) {
                            _selectedChannel = 0;
                          }
                          return ListView.separated(
                            itemCount: channels.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final bool isSelected = index == _selectedChannel;
                              final channel = channels[index];
                              final isFavorite = _favoriteStates[channel.id] ?? false;
                              final String channelName = channel.name.isEmpty
                                  ? 'Channel ${index + 1}'
                                  : channel.name;
                              final String streamUrl = channel.streamUrl.isNotEmpty
                                  ? channel.streamUrl
                                  : channel.originalData.directSource;
                              
                              return InkWell(
                                onTap: () {
                                  setState(() => _selectedChannel = index);
                                  g.Get.to(
                                    () => TvPlayerView(
                                      channelIcon: channel.originalData.streamIcon,
                                      channelName: channelName,
                                      streamUrl: streamUrl,
                                      id: channel.id,
                                      type: 'live_tv',
                                      isLive: channel.streamType == 'live',
                                    ),
                                    transition: g.Transition.fade,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.06)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Skeletonizer(
                                              effect: ShimmerEffect(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                duration: const Duration(
                                                  seconds: 1,
                                                ),
                                              ),
                                              enabled: true,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.asset(
                                                  Assets.imagesLogo,
                                                ),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            ClipRRect(
                                              child: Skeletonizer(
                                                effect: ShimmerEffect(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  duration: const Duration(
                                                    seconds: 1,
                                                  ),
                                                ),
                                                enabled: true,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.asset(
                                                    Assets.imagesLogo,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        width: 28,
                                        height: 28,
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            channel.originalData.streamIcon,
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
                                          channelName,
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
                                      const SizedBox(width: 8),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            _toggleFavorite(
                                              channel.id,
                                              channelName,
                                              channel.originalData.streamIcon,
                                              streamUrl,
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(50),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              isFavorite ? Icons.favorite : Icons.favorite_border,
                                              color: isFavorite ? Colors.red : Colors.white.withOpacity(0.7),
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        // initial state
                      return  CustomLoadingIptvChannelsListView();
                      },
                    ),
                  );
  }
}