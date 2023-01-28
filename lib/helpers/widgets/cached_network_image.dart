import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:recipe_search/helpers/consts.dart';

const maxDepth = 10;
const imageSize = 90.0;

class CustomCachedNetworkImage extends StatefulWidget {
  const CustomCachedNetworkImage({
    Key? key,
    this.depth,
    required this.url,
    this.useLocalCache = false,
  }) : super(key: key);

  final int? depth;
  final String url;
  final bool useLocalCache;

  @override
  State<CustomCachedNetworkImage> createState() => _CustomCachedNetworkImageState();
}

class _CustomCachedNetworkImageState extends State<CustomCachedNetworkImage> with TickerProviderStateMixin {
  int get depthOrZero => widget.depth ?? 0;
  late final Future<File> file;

  @override
  void initState() {
    super.initState();
    if (widget.useLocalCache) {
      file = DefaultCacheManager().getSingleFile(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useLocalCache) {
      return localCache();
    }
    return CachedNetworkImage(
      imageUrl: widget.url,
      fit: BoxFit.contain,
      placeholder: (_, __) => placeholder,
      width: imageSize,
      errorWidget: (_, __, e) => onError(e),
    );
  }

  Widget localCache() {
    return SizedBox(
      height: imageSize,
      width: imageSize,
      child: FutureBuilder<File>(
        future: file,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return Image.file(
              snapshot.requireData,
              fit: BoxFit.contain,
            );
          }
          if (snapshot.hasError) {
            return onError(snapshot.error);
          }
          return placeholderOpacity;
        },
      ),
    );
  }

  Widget onError(Object? e) {
    log("handle error depth=$depthOrZero localCache=${widget.useLocalCache}", error: e);

    if (depthOrZero > maxDepth) {
      log("max depth reached");
      return placeholder;
    }

    return CustomCachedNetworkImage(
      key: widget.key,
      url: widget.url,
      depth: depthOrZero + 1,
      useLocalCache: widget.useLocalCache,
    );
  }
}
