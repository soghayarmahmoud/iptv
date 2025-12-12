import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iptv/core/utils/app_colors.dart';

import 'package:iptv/featuers/series/presentation/manager/get_eposides/get_eposides_cubit.dart';
import 'package:iptv/featuers/series/presentation/views/widgets/eposide_gride.dart';
import 'package:iptv/featuers/series/presentation/views/widgets/eposide_top_bar.dart';

class EposidesViewBody extends StatefulWidget {
  const EposidesViewBody({super.key, required this.seriesId , required this.playlistId});
  final String seriesId;
  final String playlistId;

  @override
  State<EposidesViewBody> createState() => _EposidesViewBodyState();
}

class _EposidesViewBodyState extends State<EposidesViewBody> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {


    return Container(
      color: AppColors.mainColorTheme,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          
            
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              const SizedBox(width: 5),
            
              const SizedBox(width: 16),
              // Right side: Search + Grid
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      EposideTopBar(
                        onSearchChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<GetEposidesCubit, GetEposidesState>(
                          builder: (context, state) {
                            return EposideGrid(searchQuery: _searchQuery , seriesId: widget.seriesId , playlistId: widget.playlistId);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      
    );
  }
}

