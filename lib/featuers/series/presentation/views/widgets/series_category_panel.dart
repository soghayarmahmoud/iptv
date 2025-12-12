

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/featuers/series/data/models/series_categories_model.dart';
import 'package:iptv/featuers/series/presentation/manager/get_series/get_series_cubit.dart';

class SeriesCategoriesPanel extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final List<SeriesCategory> categories;
  final String playlistId;
  const SeriesCategoriesPanel({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categories,
    required this.playlistId,
  });

  List<String> get allCategories {
    return [...categories.map((e) => e.name)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryColorTheme,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        itemCount: allCategories.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Colors.transparent),
        itemBuilder: (context, index) {
          final String label = allCategories[index];
          final bool selected = label == selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: InkWell(
              onTap: () {
                    context.read<GetSeriesCubit>().getSeries(categories[index].id , playlistId);

                onCategorySelected(label);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.mainColorTheme.withOpacity(.6)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    label,
                    style: TextStyles.font14Medium(
                      context,
                    ).copyWith(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}