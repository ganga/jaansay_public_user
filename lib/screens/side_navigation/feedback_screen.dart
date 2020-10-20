import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Feedback"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: "mainlogo",
              child: Image.asset(
                "assets/images/feedback.png",
                height: Get.width * 0.5,
                width: Get.width * 0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Feedback",
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(8),
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 15),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
              child: Text(
                "Send",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
