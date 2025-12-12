import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/featuers/movies/presentation/manager/get_movies_category/get_movies_category_cubit.dart';
import 'package:iptv/featuers/movies/presentation/views/widgets/categories_panel.dart';
import 'package:iptv/featuers/movies/presentation/views/widgets/movies_grid.dart';
import 'package:iptv/featuers/movies/presentation/views/widgets/top_bar.dart';

class MoviesViewBody extends StatefulWidget {
  const MoviesViewBody({super.key, required this.playlistId});
  
  final String playlistId;

  @override
  State<MoviesViewBody> createState() => _MoviesViewBodyState();
}

class _MoviesViewBodyState extends State<MoviesViewBody> {
  String selectedCategory = 'All';
  String searchQuery = '';

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }
  @override
  void initState() {
    super.initState();
    context.read<GetMoviesCategoryCubit>().getMoviesCategory(widget.playlistId);
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

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
              SizedBox(
                width: size.width * 0.25,
                child: CategoriesPanel(
                  playlistId: widget.playlistId,
                  selectedCategory: selectedCategory,
                  onCategorySelected: onCategorySelected,
                ),
              ),
              const SizedBox(width: 16),
              // Right side: Search + Grid
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopBar(onSearchChanged: (q) {
                      setState(() {
                        searchQuery = q.trim();
                      });
                    }),
                    const SizedBox(height: 16),
                    Expanded(
                      child: MoviesGrid(selectedCategory: selectedCategory, searchQuery: searchQuery),
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

