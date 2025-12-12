import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/featuers/series/data/models/series_categories_model.dart';
import 'package:iptv/featuers/series/presentation/manager/get_series_categories/get_series_categories_cubit.dart';
import 'package:iptv/featuers/series/presentation/manager/get_series/get_series_cubit.dart';
import 'package:iptv/featuers/series/presentation/views/widgets/series_category_panel.dart';
import 'package:iptv/featuers/series/presentation/views/widgets/series_grid.dart';
import 'package:iptv/featuers/series/presentation/views/widgets/series_top_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SeriesViewBody extends StatefulWidget {
  const SeriesViewBody({super.key, required this.playlistId});
  
  final String playlistId;

  @override
  State<SeriesViewBody> createState() => _SeriesViewBodyState();
}

class _SeriesViewBodyState extends State<SeriesViewBody> {
  String selectedCategory = 'All';
  bool _initialSeriesFetched = false;
  String searchQuery = '';

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<GetSeriesCategoriesCubit>().getSeriesCategories(widget.playlistId);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Container(
      color: AppColors.mainColorTheme,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<GetSeriesCategoriesCubit, GetSeriesCategoriesState>(
            listener: (context, state) {
              if (!_initialSeriesFetched && state is GetSeriesCategoriesSuccess && state.seriesCategoriesModel.categories.isNotEmpty) {
                final SeriesCategory first = state.seriesCategoriesModel.categories.first;
                _initialSeriesFetched = true;
                selectedCategory = first.name;
                context.read<GetSeriesCubit>().getSeries(first.id , widget.playlistId);
              }
            },
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
              SizedBox(
                width: size.width * 0.25,
                child: BlocBuilder<GetSeriesCategoriesCubit, GetSeriesCategoriesState>(
                  builder: (context, state) {
                    if (state is GetSeriesCategoriesLoading || state is GetSeriesCategoriesError) {
                     return Skeletonizer(
                       effect: ShimmerEffect(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        duration: const Duration(seconds: 1),
                      ),
                      enabled: true,
                       child: SeriesCategoriesPanel(
                        playlistId: widget.playlistId,
                          selectedCategory: selectedCategory,
                          onCategorySelected: onCategorySelected,
                          categories: [
                            SeriesCategory(id: '', name: 'Loading...', parentId: 0),
                            SeriesCategory(id: '', name: 'Please wait...', parentId: 0),
                            SeriesCategory(id: '', name: 'Loading...', parentId: 0),
                          ],
                        ),
                     );
                    
                    } else if (state is GetSeriesCategoriesSuccess) {
                      return SeriesCategoriesPanel(
                        playlistId: widget.playlistId,
                        selectedCategory: selectedCategory,
                        onCategorySelected: onCategorySelected,
                        categories: state.seriesCategoriesModel.categories,
                      );
                    }
                      return Skeletonizer(
                       effect: ShimmerEffect(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        duration: const Duration(seconds: 1),
                      ),
                      enabled: true,
                       child: SeriesCategoriesPanel(
                        playlistId: widget.playlistId,
                          selectedCategory: selectedCategory,
                          onCategorySelected: onCategorySelected,
                          categories: [
                            SeriesCategory(id: '', name: 'Loading...', parentId: 0),
                            SeriesCategory(id: '', name: 'Please wait...', parentId: 0),
                            SeriesCategory(id: '', name: 'Loading...', parentId: 0),
                          ],
                        ),
                     );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Right side: Search + Grid
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      SeriesTopBar(
                        onSearchChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    const SizedBox(height: 16),
                      Expanded(
                        child: SeriesGrid(selectedCategory: selectedCategory, searchQuery: searchQuery , playlistId: widget.playlistId),
                      ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

