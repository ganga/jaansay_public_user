import 'package:flutter/material.dart';

class GrievanceStatus extends StatelessWidget {
  final int isClosed;

  GrievanceStatus(this.isClosed);

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    if (isClosed == 1) {
      color = Colors.red;
      text = "Closed";
    } else {
      color = Colors.green;
      text = "Open";
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: color,
            size: 15,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
