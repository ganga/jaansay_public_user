import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/feed/feed_detail_screen.dart';
import 'package:jaansay_public_user/screens/feed/feed_list_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: 0,
      children: <Widget>[
        FeedListScreen(),
        FeedDetailScreen(),
      ],
    );
  }
}
