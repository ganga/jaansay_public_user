import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/feedCard.dart';

class FeedDetails extends StatelessWidget {
  FeedDetails({Key key}) : super(key: key);
  List<Map<String, dynamic>> feedDetail = [
    {
      'feedId': 1,
      'feedDescription': "Description",
      'time': DateTime.now(),
      'feedType': "Image",
      'feedRes': [
        "https://i.pinimg.com/originals/ca/76/0b/ca760b70976b52578da88e06973af542.jpg",
        "https://i.pinimg.com/originals/ca/76/0b/ca760b70976b52578da88e06973af542.jpg"
      ],
      'userName': "User",
      'userId': 1,
      'userProfile':
          "https://i.pinimg.com/originals/ca/76/0b/ca760b70976b52578da88e06973af542.jpg",
      'categoryName': "public",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
      ),
      body: ListView.builder(
        itemCount: feedDetail.length,
        itemBuilder: (context, index) {
          return FeedCard(feedDetail[index]);
        },
      ),
    );
  }
}
