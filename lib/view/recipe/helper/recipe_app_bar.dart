import 'package:flutter/material.dart' hide Image;

import '../../../helpers/app_colors.dart';
import '../../../helpers/consts.dart';
import '../../../helpers/images/images_model.dart';
import '../../../helpers/widgets/cached_network_image.dart';

final flexiblePlaceholder = FlexibleSpaceBar(background: placeholderMedium);

class RecipeAppBar extends StatelessWidget {
  RecipeAppBar({Key? key, this.image, required this.isFavorite}) : super(key: key);

  final Image? image;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 40,
      leading: Padding(
        padding: EdgeInsets.all(2.0),
        child: RawMaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          elevation: 2.0,
          fillColor: AppColors.indigoButton,
          shape: CircleBorder(),
          child: Icon(Icons.arrow_back_rounded, size: 35.0),
        ),
      ),
      backgroundColor: Colors.white,
      pinned: true,
      stretch: true,
      expandedHeight: 200,
      flexibleSpace: image == null
          ? flexiblePlaceholder
          : CacheImage.create(
              url: image!.url,
              useLocalCache: isFavorite,
              size: imageSizeFill,
            ),
    );
  }
}
