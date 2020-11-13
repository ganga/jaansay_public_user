import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:easy_localization/easy_localization.dart';

class FollowButton extends StatelessWidget {
  final bool isFollow;
  final String text;
  final Official official;
  final Function onTap;

  FollowButton(this.isFollow, this.text, this.official, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: isFollow ? Theme.of(context).primaryColor : Colors.black54,
              width: 0.5),
          color: isFollow
              ? Theme.of(context).primaryColor
              : Colors.black.withOpacity(0.01)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            onTap(official);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                "$text",
                style: TextStyle(color: isFollow ? Colors.white : Colors.black),
              ).tr(),
            ),
          ),
        ),
      ),
    );
  }
}
