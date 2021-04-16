import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
