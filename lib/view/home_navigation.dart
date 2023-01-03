import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/view/recipe/favorite_recipes.dart';
import 'package:recipe_search/view/search/search_page.dart';

import '../helpers/widgets/screen_data.dart';

class HomeNavigation extends StatefulWidget {
  final User? user;
  final String? deviceId;

  const HomeNavigation({
    Key? key,
    this.user,
    this.deviceId,
  })  : assert(user != null || deviceId != null),
        super(key: key);

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedScreenIndex = 0;
  late final List<ScreenData> _screens;

  void _selectScreen(int index) {
    if (mounted) {
      setState(() => _selectedScreenIndex = index);
    }
  }

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    final suffix = user?.displayName?.isNotEmpty == true ? " — ${user?.displayName ?? 'Unknown'}" : "";

    _screens = [
      ScreenData(
        widget: SearchPage(user: widget.user, deviceId: widget.deviceId),
        title: "Recipe search$suffix",
      ),
      ScreenData(
        widget: const FavoriteRecipes(),
        title: "Favorite recipes$suffix",
      ),
    ];
  }

  bool get firstPage => _selectedScreenIndex == 0;
  bool get secondPage => _selectedScreenIndex == 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedScreenIndex].title),
      ),
      body: _screens[_selectedScreenIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        selectedItemColor: secondPage ? AppColors.redLetter : null,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search, size: firstPage ? 30 : 27), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_outline_rounded,
              size: secondPage ? 30 : 27,
            ),
            label: "Favorite",
          )
        ],
      ),
    );
  }
}
