import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/feed/feed_list_top.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  bool isLoad = true;

  List<Feed> feeds = [];

  followList(Size size) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              "Stores near you",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: PageScrollPhysics(),
              itemCount: 50,
              itemBuilder: (_, index) {
                return FeedListTop(mediaQuery: size);
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomDivider()),
        ],
      ),
    );
  }

  getFeedData() async {
    FeedService feedService = FeedService();
    feeds = await feedService.getLastTwoFeeds();
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFeedData();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: feeds.length + 1,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            return index == 0
                ? followList(_mediaQuery)
                : FeedCard(feeds[index - 1]);
          }),
    );
  }
}
