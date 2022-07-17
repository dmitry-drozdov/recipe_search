import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  final Color color;
  final bool show;

  const CircularLoading(this.color, {this.show = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return show
        ? CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          )
        : const SizedBox();
  }
}
