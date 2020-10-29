import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyScreen extends StatelessWidget {
  Widget ans(IconData ic, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        Icon(ic),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Survey"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              height: Get.height * 0.4,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How would your country change if everyone, regardless of age, could vote",
                    style: TextStyle(fontSize: 18),
                  ),
                  ans(Icons.radio_button_off, "Good"),
                  ans(Icons.radio_button_off, "Bad"),
                  ans(Icons.radio_button_checked, "Very Good"),
                  ans(Icons.radio_button_off, "Very Bad"),
                ],
              ),
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}
