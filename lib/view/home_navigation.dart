import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/view/recipe/favorite_recipes.dart';
import 'package:recipe_search/view/search/search_page.dart';
import 'package:recipe_search/viewmodels/viewmodel_provider.dart';

import '../helpers/widgets/screen_data.dart';
import '../main.dart';
import '../models/app_user.dart';
import '../utils/auth.dart';
import 'common/confirm_dialog.dart';
import 'landing/landing.dart';

class HomeNavigation extends StatefulWidget {
  final AppUser user;

  const HomeNavigation({
    Key? key,
    required this.user,
  }) : super(key: key);

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
    final suffix = widget.user.title;

    _screens = [
      ScreenData(
        widget: SearchPage(user: widget.user),
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

  bool get isGoogleAuth => widget.user.googleAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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

  AppBar buildAppBar() {
    return AppBar(
      title: Text(_screens[_selectedScreenIndex].title),
      actions: [
        RawMaterialButton(
          onPressed: () async {
            final exit = await onExit();
            if (exit == ExitType.cancel || !mounted) {
              return;
            }
            if (isGoogleAuth) {
              await locator<Authentication>().signOut(cleanAppUser: exit == ExitType.yesAlways);
            }
            if (!mounted) {
              return;
            }
            ViewModelProvider.delete(recipeKey);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const Landing(title: 'Recipe Search Landing'),
              ),
            );
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.logout),
        ),
      ],
    );
  }

  Future<ExitType?> onExit() async {
    return await showDialog<ExitType>(
          context: context,
          builder: (BuildContext context) => ConfirmDialog(
            title: 'Confirm log out',
            content: 'Are you sure you want to log out?',
            yesNowText: 'Log out',
            yesAlwaysText: isGoogleAuth ? 'Log out and forget' : null,
            cancelText: 'Cancel',
          ),
        ) ??
        ExitType.cancel;
  }
}
