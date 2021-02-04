import 'package:flutter/material.dart';

class CustomNetWorkImage extends StatelessWidget {
  final photo;

  CustomNetWorkImage(this.photo);

  @override
  Widget build(BuildContext context) {
    return photo == null || photo == "no photo"
        ? Image.asset(
            "assets/images/profileHolder.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : FadeInImage(
            image: NetworkImage("$photo"),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.topCenter,
            placeholder: AssetImage("assets/images/profileHolder.jpg"),
          );
  }
}
