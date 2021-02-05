import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';

class FeedDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List response = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: FeedCard(
            isDetail: true,
            feed: response[0],
            isBusiness: response[1],
          ),
        ),
      ),
    );
  }
}
