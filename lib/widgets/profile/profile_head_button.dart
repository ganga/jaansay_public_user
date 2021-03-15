import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileHeadButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool isColor;

  ProfileHeadButton({this.title, this.onTap, this.isColor = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: isColor ? Theme.of(context).primaryColor : Colors.black54,
              width: 0.5),
          color: isColor
              ? Theme.of(context).primaryColor
              : Colors.black.withOpacity(0.01),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white,
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style:
                        TextStyle(color: isColor ? Colors.white : Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).tr(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
