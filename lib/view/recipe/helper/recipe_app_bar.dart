import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Image;

import '../../../helpers/app_colors.dart';
import '../../../helpers/consts.dart';
import '../../../helpers/images/images_model.dart';

final flexiblePlaceholder = FlexibleSpaceBar(background: placeholderMedium);

class RecipeAppBar extends StatelessWidget {
  const RecipeAppBar({Key? key, this.image}) : super(key: key);

  final Image? image;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 40,
      leading: Padding(
        padding: const EdgeInsets.all(2.0),
        child: RawMaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          elevation: 2.0,
          fillColor: AppColors.indigoButton,
          shape: const CircleBorder(),
          child: const Icon(Icons.arrow_back_rounded, size: 35.0),
        ),
      ),
      backgroundColor: Colors.white,
      pinned: true,
      stretch: true,
      expandedHeight: 200,
      flexibleSpace: image == null
          ? flexiblePlaceholder
          : CachedNetworkImage(
              imageUrl: image!.url,
              placeholder: (_, __) => placeholderLarge,
              fit: BoxFit.cover,
            ),
    );
  }
}
