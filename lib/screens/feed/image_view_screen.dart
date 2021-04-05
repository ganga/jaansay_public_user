import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatefulWidget {
  static const routeName = '/imageView';

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  bool code = false;
  String passValue = "";

  @override
  Widget build(BuildContext context) {
    passValue = ModalRoute.of(context).settings.arguments as String;

    return Center(
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(passValue),
      ),
    );
  }
}
