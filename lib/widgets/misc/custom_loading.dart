import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final String title;

  CustomLoading(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 5,
          ),
          Text("$title"),
        ],
      ),
    );
  }
}
