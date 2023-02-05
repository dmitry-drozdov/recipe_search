import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:recipe_search/helpers/consts.dart';

const maxDepth = 10;
const imageSize = 95.0;
const double? imageSizeFill = null;

class CacheImage extends StatefulWidget {
  static CacheImage create({
    Key? key,
    required String url,
    required bool useLocalCache,
    double? size = imageSize,
  }) {
    return CacheImage._(
      key: key,
      url: url,
      useLocalCache: useLocalCache,
      size: size,
    );
  }

  const CacheImage._({
    Key? key,
    this.depth,
    required this.url,
    required this.useLocalCache,
    this.size = imageSize,
  }) : super(key: key);

  final int? depth;
  final String url;
  final bool useLocalCache;
  final double? size;

  @override
  State<CacheImage> createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> with TickerProviderStateMixin {
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
      fit: BoxFit.cover,
      placeholder: (_, __) => _placeholder,
      width: widget.size,
      errorWidget: (_, __, e) => onError(e),
    );
  }

  Widget localCache() {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: FutureBuilder<File>(
        future: file,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return Image.file(
              snapshot.requireData,
              fit: BoxFit.cover,
            );
          }
          if (snapshot.hasError) {
            return onError(snapshot.error);
          }
          return _placeholder;
        },
      ),
    );
  }

  Widget onError(Object? e) {
    log("handle error depth=$depthOrZero localCache=${widget.useLocalCache}", error: e);

    if (depthOrZero > maxDepth) {
      log("max depth reached");
      return _placeholder;
    }

    return CacheImage._(
      key: widget.key,
      url: widget.url,
      depth: depthOrZero + 1,
      useLocalCache: widget.useLocalCache,
      size: widget.size,
    );
  }

  Widget get _placeholder {
    return Center(child: widget.size == imageSizeFill ? placeholderLarge : placeholder);
  }
}
