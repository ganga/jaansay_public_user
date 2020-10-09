import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';

class FeedListScreen extends StatelessWidget {
  FeedListScreen({Key key}) : super(key: key);
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
          "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
      'categoryName': "public",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return FeedCard(feedDetail[0]);
        },
      ),
    );
  }
}
