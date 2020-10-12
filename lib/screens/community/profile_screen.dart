import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/profile/officials_profile_head.dart';
import 'package:jaansay_public_user/widgets/profile/public_profile_head.dart';

class ProfileScreen extends StatelessWidget {
  List<Map<String, dynamic>> feedDetail = [
    {
      'feedId': 1,
      'feedDescription':
          "The world these days, governed by competition, makes survival the most difficult thing. And for those whose existence is challenging hope is the only way of survival. This is one way, life can be summed up in words. The fact however is, life cannot be summed up in words. Words fail to express the meaning and purpose that anyone feels he or she has in life. For some it might be to create or build something, for someone it might be gaining knowledge, for someone it might be to have fun.",
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
    final String type = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.05),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return index == 0
                      ? type == "public"
                          ? PublicProfileHead()
                          : OfficialsProfileHead(type)
                      : FeedCard(feedDetail[0]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
