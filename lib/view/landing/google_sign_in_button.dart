import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_search/helpers/consts.dart';
import 'package:recipe_search/helpers/extensions/edge_extension.dart';

import '../../helpers/widgets/circular_indicator.dart';
import '../../main.dart';
import '../../utils/auth.dart';

class GoogleSignInButton extends StatefulWidget {
  final Function(User) onSignIn;
  const GoogleSignInButton({
    Key? key,
    required this.onSignIn,
  }) : super(key: key);

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final auth = locator<Authentication>();

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: signButtonStyle,
      onPressed: () async {
        setState(() => _isSigningIn = true);

        final user = await auth.signInWithGoogle();
        if (!mounted) return;

        setState(() => _isSigningIn = false);

        if (user == null) return;
        widget.onSignIn(user);
      },
      child: _isSigningIn
          ? CircularLoading(Theme.of(context).primaryColor).paddingV8
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.vpn_key_outlined),
                const SizedBox(width: 5),
                Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ).paddingV8,
    );
  }
}
