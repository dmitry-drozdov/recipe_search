import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:recipe_search/helpers/consts.dart';
import 'package:recipe_search/helpers/extensions/widget_extension.dart';

import '../../helpers/widgets/circular_indicator.dart';
import '../../main.dart';
import '../../utils/auth.dart';
import '../../utils/internet_checker.dart';

class GoogleSignInButton extends StatefulWidget {
  final Function(User) onSignIn;

  GoogleSignInButton({
    Key? key,
    required this.onSignIn,
  }) : super(key: key);

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final auth = locator<Authentication>();
  final checker = locator<InternetChecker>();

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InternetConnectionStatus>(
      stream: checker.onStatusChange,
      initialData: checker.lastStatus,
      builder: (_, __) {
        return signInButton(checker);
      },
    );
  }

  Widget signInButton(InternetChecker checker) {
    return OutlinedButton(
      style: signButtonStyle,
      onPressed: _isSigningIn || checker.disconnected ? null : onPressed,
      child: _isSigningIn
          ? CircularLoading().paddingV8
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.vpn_key_outlined),
                SizedBox(width: 5),
                Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )
              ],
            ).paddingV8,
    );
  }

  Future<void> onPressed() async {
    setState(() => _isSigningIn = true);

    final user = await auth.signInWithGoogle();
    if (!mounted) {
      return;
    }

    setState(() => _isSigningIn = false);

    if (user != null) {
      widget.onSignIn(user);
    }
  }
}
