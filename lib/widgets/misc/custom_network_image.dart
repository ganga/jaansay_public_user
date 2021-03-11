import 'package:flutter/material.dart';

class CustomNetWorkImage extends StatelessWidget {
  final photo;

  CustomNetWorkImage(this.photo);

  @override
  Widget build(BuildContext context) {
    String filteredPhoto = photo;
    if (photo != null && photo != "no photo" && photo != '') {
      filteredPhoto = photo.toString().replaceAll(' ', '%20');
    }

    return filteredPhoto == null ||
            filteredPhoto == "no photo" ||
            filteredPhoto == ''
        ? Image.asset(
            "assets/images/profileHolder.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : FadeInImage(
            image: NetworkImage(filteredPhoto.toString()),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.topCenter,
            placeholder: AssetImage("assets/images/profileHolder.jpg"),
          );
  }
}
