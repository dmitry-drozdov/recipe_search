import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/models/app_user.dart';

import '../../main.dart';
import '../../utils/auth.dart';
import '../home_navigation.dart';
import 'google_sign_in_button.dart';

class Landing extends StatefulWidget {
  final String title;

  const Landing({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final auth = locator<Authentication>();

  var useLastKnownData = true;

  @override
  Widget build(BuildContext context) {
    final darkColor = Theme.of(context).primaryColorDark;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/images/logo.jpg'),
          highLightFirstLetter(
            text: 'Welcome to \nRecipe Search App!',
            style: TextStyle(
              color: darkColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            firstLetterColor: AppColors.redLetter,
          ),
          highLightFirstLetter(
            text: 'Search & Review & Keep',
            style: TextStyle(
              color: darkColor,
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
            firstLetterColor: AppColors.redLetter,
          ),
          const SizedBox(height: 50),
          buttons(),
        ],
      ),
    );
  }

  Widget highLightFirstLetter({
    required String text,
    required TextStyle style,
    required Color firstLetterColor,
  }) {
    assert(text.length > 1);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: text[0],
        style: style.copyWith(color: firstLetterColor),
        children: [
          TextSpan(
            text: text.substring(1),
            style: style,
          ),
        ],
      ),
    );
  }

  Widget buttons() {
    final buttonStyle = TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 16);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        auth.firebaseApp == null
            ? const Text('Error initializing Firebase')
            : GoogleSignInButton(onSignIn: (googleUser) => onAuthGoogle(googleUser)),
        Divider(
          color: AppColors.blueBorder,
          indent: 25,
          endIndent: 25,
        ),
        TextButton(
          child: Text('Continue without sign in', style: buttonStyle),
          onPressed: () {
            onWithoutAuth();
          },
        ),
        useLastSaved(),
      ],
    );
  }

  Widget useLastSaved() {
    return FutureBuilder<AppUser?>(
      future: auth.getLastKnownAppUser(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return toggleRow();
        }
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        return const SizedBox(height: 46);
      },
    );
  }

  Widget toggleRow() {
    final buttonStyle = TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 15);
    return Opacity(
      opacity: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("*Use data last saved with Google", style: buttonStyle),
          Switch(
            inactiveTrackColor: AppColors.lightBlueChip,
            value: useLastKnownData,
            onChanged: (val) {
              if (mounted) setState(() => useLastKnownData = val);
            },
          ),
        ],
      ),
    );
  }

  Future<void> onWithoutAuth() async {
    AppUser? appUser;
    if (useLastKnownData) {
      appUser = await auth.getLastKnownAppUser();
    }

    appUser ??= await AppUser.create();
    navigateToMain(appUser);
  }

  Future<void> onAuthGoogle(User googleUser) async {
    final appUser = await AppUser.create(googleUser: googleUser);
    auth.rememberAppUser(appUser);
    navigateToMain(appUser);
  }

  void navigateToMain(AppUser appUser) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeNavigation(user: appUser),
      ),
    );
  }
}
