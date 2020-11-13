import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomAuthButton extends StatelessWidget {
  final String title;
  final Function onTap;

  CustomAuthButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 15),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          onTap();
        },
        child: Text(
          "$title",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ).tr(),
      ),
    );
  }
}
