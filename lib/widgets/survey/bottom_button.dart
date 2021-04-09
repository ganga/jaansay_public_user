import 'package:flutter/material.dart';
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
