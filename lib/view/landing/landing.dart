import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:recipe_search/helpers/app_colors.dart';
import 'package:recipe_search/helpers/extensions/edge_extension.dart';

import '../../helpers/widgets/circular_indicator.dart';
import '../../utils/auth.dart';
import '../home_navigation.dart';
import 'google_sign_in_button.dart';

class Landing extends StatelessWidget {
  final String title;

  const Landing({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final darkColor = Theme.of(context).primaryColorDark;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
            text: 'Searching & Reviewing & Saving',
            style: TextStyle(
              color: darkColor,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            firstLetterColor: AppColors.redLetter,
          ),
          const SizedBox(height: 50),
          buttons(context),
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

  Widget buttons(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FutureBuilder(
          future: Authentication.initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return GoogleSignInButton(onSignIn: (user) => navigateToMain(ctx, user: user));
            }
            return CircularLoading(Theme.of(context).primaryColor).paddingV8;
          },
        ),
        TextButton(
          child: const Text('Continue without sign in'),
          onPressed: () async {
            String? deviceId = await PlatformDeviceId.getDeviceId;
            navigateToMain(ctx, deviceId: deviceId);
          },
        ),
      ],
    );
  }

  void navigateToMain(BuildContext ctx, {User? user, String? deviceId}) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeNavigation(user: user, deviceId: deviceId),
      ),
    );
  }
}
