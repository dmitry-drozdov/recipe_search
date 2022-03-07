enum ImageType { thumbnail, small, regular, large, unknown }

extension ImageTypeExtension on ImageType {
  String get apiName => name.toUpperCase();
}

ImageType apiToImageType(String value) {
  return ImageType.values
      .firstWhere((element) => element.apiName == value.toUpperCase(), orElse: () => ImageType.unknown);
}
