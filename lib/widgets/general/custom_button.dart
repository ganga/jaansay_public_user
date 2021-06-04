// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class BottomButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color backColor;
  final Color textColor;
  final bool isDisabled;

  BottomButton(
      {this.onTap,
      this.text,
      this.backColor,
      this.textColor,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDisabled ? Colors.grey : backColor ?? Get.theme.primaryColor,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
                letterSpacing: 1.05,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

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
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
