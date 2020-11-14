import 'package:flutter/material.dart';

class CustomNetWorkImage extends StatelessWidget {
  final photo;

  CustomNetWorkImage(this.photo);

  @override
  Widget build(BuildContext context) {
    return photo == "no photo"
        ? Image.network(
            "https://qph.fs.quoracdn.net/main-qimg-2b21b9dd05c757fe30231fac65b504dd",
            fit: BoxFit.cover,
          )
        : Image.network(
            "$photo",
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          );
  }
}
