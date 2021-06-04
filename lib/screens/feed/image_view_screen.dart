// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  final String passValue;

  ImageViewScreen(this.passValue);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(passValue),
      ),
    );
  }
}
