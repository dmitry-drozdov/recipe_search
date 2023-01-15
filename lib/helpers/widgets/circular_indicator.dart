import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  final Color? color;
  final bool show;

  const CircularLoading({this.color, this.show = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: show
          ? CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context).primaryColor),
            )
          : null,
    );
  }
}
