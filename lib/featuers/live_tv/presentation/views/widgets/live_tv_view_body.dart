// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iptv/core/utils/app_colors.dart';

import 'package:iptv/core/utils/app_styles.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/featuers/live_tv/presentation/manager/get_iptv_categories/get_iptv_categories_cubit.dart';
import 'package:iptv/featuers/live_tv/presentation/manager/get_iptv_channels/get_iptv_channels_cubit.dart';
import 'package:iptv/featuers/live_tv/presentation/views/widgets/bloc_of_get_custom_iptv_categories.dart';
import 'package:iptv/featuers/live_tv/presentation/views/widgets/bloc_of_get_iptv_channels.dart';
import 'package:iptv/generated/l10n.dart';

class LiveTvViewBody extends StatefulWidget {
  const LiveTvViewBody({super.key, required this.playlistId});
  
  final String playlistId;

  @override
  State<LiveTvViewBody> createState() => _LiveTvViewBodyState();
}

class _LiveTvViewBodyState extends State<LiveTvViewBody> {
  String get timeText => DateFormat('hh:mm a').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // Fetch categories once when entering the view
    context.read<GetIptvCategoriesCubit>().getIptvCategories(widget.playlistId);
    // Ensure channels state shows loading (or initial) on page entry
    context.read<GetIptvChannelsCubit>().setLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondaryColorTheme, AppColors.mainColorTheme],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Stack(
          children: [
            SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left categories
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                S.current.Live_Channels,
                                style: TextStyles.font22ExtraBold(
                                  context,
                                ).copyWith(color: AppColors.whiteColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        BlocOfGetCustomIptvCategories(playlistId: widget.playlistId),
                      ],
                    ),
                  ),

                  VerticalDivider(
                    color: AppColors.whiteColor,
                    thickness: 0.3,
                    width: 1,
                  ),
                  const SizedBox(width: 10),
                  // Middle channels list
                  BlocOfGetIptvChannels(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
