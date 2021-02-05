import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomErrorWidget extends StatefulWidget {
  final String title;
  final IconData iconData;

  CustomErrorWidget({this.title, this.iconData});

  @override
  _CustomErrorWidgetState createState() => _CustomErrorWidgetState();
}

class _CustomErrorWidgetState extends State<CustomErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Get.width * 0.17,
            width: Get.width * 0.17,
            padding: EdgeInsets.all(Get.width * 0.05),
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(
              widget.iconData,
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            widget.title,
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.05),
          ),
        ],
      ),
    );
  }
}
