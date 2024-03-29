import 'package:flutter/cupertino.dart';

extension EdgeInsetsExtension on Widget {
  Widget get padding8880 => Padding(padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0), child: this);
  Widget get padding8888 => Padding(padding: const EdgeInsets.all(8.0), child: this);
  Widget get paddingB8 => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: this);
  Widget get paddingV8 => Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: this);
  Widget get paddingH8 => Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: this);
  Widget get paddingV1 => Padding(padding: const EdgeInsets.symmetric(vertical: 1.0), child: this);
}

extension IgnoringExtension on Widget {
  Widget hide(bool ignoring) {
    return Opacity(
      opacity: ignoring ? 0.5 : 1,
      child: IgnorePointer(
        ignoring: ignoring,
        child: this,
      ),
    );
  }
}
