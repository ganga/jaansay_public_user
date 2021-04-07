import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  final String title;
  final Function onTap;

  CustomAuthButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: onTap == null
            ? null
            : () {
                onTap();
              },
        child: Text(
          "$title",
        ).tr(),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
