import 'package:flutter/material.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomLoadingIptvCategoriesListView extends StatefulWidget {
  const CustomLoadingIptvCategoriesListView({super.key});

  @override
  State<CustomLoadingIptvCategoriesListView> createState() => _CustomLoadingIptvCategoriesListViewState();
}

class _CustomLoadingIptvCategoriesListViewState extends State<CustomLoadingIptvCategoriesListView> {
  List<String> fakeCategories = [
    'Faviourte',
    'Recents',
    'Recents',
    'Recents',
    'Recents',
    'Recents',
    'Recents',
  ];
    int _selectedCategory = 0;
  @override
  Widget build(BuildContext context) {
     return Skeletonizer(
                                  effect: ShimmerEffect(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    duration: const Duration(seconds: 1),
                                  ),
                                  enabled: true,
                                  child: ListView.builder(
                                    itemCount: fakeCategories.length,
                                    itemBuilder: (context, index) {
                                      final bool isSelected =
                                          index == _selectedCategory;
                                      final name = fakeCategories[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () => setState(
                                            () => _selectedCategory = index,
                                          ),
                                          child: Text(
                                            name,
                                            style:
                                                (isSelected
                                                        ? TextStyles.font20ExtraBold(
                                                            context,
                                                          )
                                                        : TextStyles.font18Medium(
                                                            context,
                                                          ))
                                                    .copyWith(
                                                      color: isSelected
                                                          ? AppColors.whiteColor
                                                          : AppColors
                                                                .subGreyColor,
                                                    ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
  }
}