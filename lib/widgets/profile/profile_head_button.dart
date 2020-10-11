import 'package:flutter/material.dart';

class ProfileHeadButton extends StatelessWidget {
  final double width;
  final String title;
  final Function onTap;

  ProfileHeadButton(this.width, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black54, width: 0.5),
          color: Colors.black.withOpacity(0.01)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Align(
                alignment: Alignment.center,
                child: Text(title),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
