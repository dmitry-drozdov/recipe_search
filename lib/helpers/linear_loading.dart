import 'package:flutter/material.dart';

class LinearLoading extends StatelessWidget {
  final Color color;
  final bool show;

  const LinearLoading(this.color, {this.show = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      child: show
          ? LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            )
          : null,
    );
  }
}
