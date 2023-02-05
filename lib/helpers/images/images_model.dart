import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'image_type.dart';

part 'images_model.g.dart';

@JsonSerializable(createToJson: true)
class Image {
  @JsonKey(ignore: true)
  @protected
  ImageType? imageType;
  final String url;
  final double width;
  final double height;

  Image({
    this.imageType,
    required this.url,
    required this.width,
    required this.height,
  });

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}

class Images {
  final List<Image> images;

  Images({required this.images});

  factory Images.fromJson(Map<String, dynamic> json) {
    final result = <Image>[];
    json.forEach((key, value) {
      final imageType = apiToImageType(key);
      if (imageType == ImageType.unknown) {
        log('Images.fromJson| Incorrect image type: $key. Skipped');
      } else {
        final img = Image.fromJson(json[key]);
        img.imageType = imageType;
        result.add(img);
      }
    });
    return Images(images: result);
  }

  Image? get thumbnail => images.firstWhereOrNull((element) => element.imageType == ImageType.thumbnail);

  Image? get small => images.firstWhereOrNull((element) => element.imageType == ImageType.small);

  Image? get regular => images.firstWhereOrNull((element) => element.imageType == ImageType.regular);

  Image? get large => images.firstWhereOrNull((element) => element.imageType == ImageType.large);
}

Map<String, dynamic> imagesToJson(Images im) {
  final json = <String, dynamic>{};
  for (final img in im.images) {
    final type = img.imageType ?? ImageType.unknown;
    json[type.apiName] = img.toJson();
  }
  return json;
}
