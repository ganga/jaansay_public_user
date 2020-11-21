import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileHeadButton extends StatefulWidget {
  final double width;
  final dynamic code;
  final String title;
  final Function onTap;

  ProfileHeadButton(this.width, this.code, this.title, this.onTap);

  @override
  _ProfileHeadButtonState createState() => _ProfileHeadButtonState();
}

class _ProfileHeadButtonState extends State<ProfileHeadButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: widget.code != null
                  ? Colors.black54
                  : Theme.of(context).primaryColor,
              width: 0.5),
          color: widget.code != null
              ? Colors.black.withOpacity(0.01)
              : Theme.of(context).primaryColor),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            if (widget.title != "Requested") {
              widget.onTap();
            } else {
              if (widget.code == null || widget.code == 0) {
                widget.onTap();
                setState(() {});
              }
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.code != null
                      ? widget.code == 0
                          ? widget.title == "Requested"
                              ? "Accept"
                              : widget.title
                          : "Following"
                      : "Follow",
                  style: TextStyle(
                      color: widget.code != null ? Colors.black : Colors.white),
                  maxLines: 1,
                ).tr(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
