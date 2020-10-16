import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final bool isFollow;
  final String text;

  FollowButton(this.isFollow, this.text);

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
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                "$text",
                style: TextStyle(color: isFollow ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
