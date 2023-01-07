import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:recipe_search/helpers/consts.dart';

const maxDepth = 10;

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    Key? key,
    this.depth,
    required this.url,
  }) : super(key: key);

  final int? depth;
  final String url;

  int get depthOrZero => depth ?? 0;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      placeholder: (_, __) => placeholder,
      width: 90,
      errorWidget: (_, __, e) {
        log("handle error $depthOrZero", error: e);

        if (depthOrZero > maxDepth) {
          log("max depth reached");
          return placeholder;
        }

        return CustomCachedNetworkImage(
          key: key,
          url: url,
          depth: depthOrZero + 1,
        );
      },
    );
  }
}
