
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/featuers/movies/data/models/movie_category_model.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movies/get_movies_cubit.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movies_category/get_movies_category_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesPanel extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final String playlistId;

  const CategoriesPanel({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryColorTheme,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: BlocBuilder<GetMoviesCategoryCubit, GetMoviesCategoryState>(
        builder: (context, state) {
          // Always include base categories
          final List<MovieCategory> baseCategories = <MovieCategory>[];

          if (state is GetMoviesCategoryLoading || state is GetMoviesCategoryError) {
            final placeholders = <MovieCategory>[
              const MovieCategory(id: '', name: 'Loading...', parentId: 0),
              const MovieCategory(id: '', name: 'Please wait...', parentId: 0),
              const MovieCategory(id: '', name: 'Loading...', parentId: 0),
            ];
            return Skeletonizer(
              effect: ShimmerEffect(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                duration: const Duration(seconds: 1),
              ),
              enabled: true,
              child: _buildCategoriesList(context, placeholders),
            );
          }

        

          if (state is GetMoviesCategorySuccess) {
            final List<MovieCategory> dynamicCategories = state.movieCategoriesResponse.categories
                .where((c) => c.name.trim().isNotEmpty)
                .toList();

            // Auto-select and fetch for the first category if current selection is not in the list
            final bool hasSelection = dynamicCategories.any((c) => c.name == selectedCategory);
            if (dynamicCategories.isNotEmpty && !hasSelection) {
              final MovieCategory first = dynamicCategories.first;
              // Defer actions until after this frame to avoid setState in build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<GetMoviesCubit>().getMovies(first.id , playlistId);
                onCategorySelected(first.name);
              });
            }

            // Deduplicate by id while preserving order
            final Map<String, MovieCategory> byId = <String, MovieCategory>{};
            for (final c in [...baseCategories, ...dynamicCategories]) {
              byId[c.id] = c;
            }
            final List<MovieCategory> allCategories = byId.values.toList();
            return _buildCategoriesList(context, allCategories);
          }

          // Initial state
          return _buildCategoriesList(context, baseCategories);
        },
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context, List<MovieCategory> categories) {
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.transparent),
      itemBuilder: (context, index) {
        final MovieCategory label = categories[index];
        final bool selected = label.name == selectedCategory;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: InkWell(
            onTap: () {
              context.read<GetMoviesCubit>().getMovies(label.id , playlistId);
              onCategorySelected(label.name);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: selected ? AppColors.mainColorTheme.withOpacity(.6) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  label.name,
                  style: TextStyles.font14Medium(
                    context,
                  ).copyWith(color: AppColors.whiteColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}