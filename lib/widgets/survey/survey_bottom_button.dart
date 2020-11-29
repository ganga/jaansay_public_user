import 'package:flutter/material.dart';

class SurveyBottomButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color backColor;
  final Color textColor;

  SurveyBottomButton({this.onTap, this.text, this.backColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backColor,
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
                color: textColor,
                fontSize: 16,
                letterSpacing: 1.05,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
