import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';

class FeedDetailScreen extends StatelessWidget {
  Feed feed;

  @override
  Widget build(BuildContext context) {
    final List response = ModalRoute.of(context).settings.arguments;
    feed = response[0];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: FeedCard(
            isDetail: true,
            feed: feed,
          ),
        ),
      ),
    );
  }
}
