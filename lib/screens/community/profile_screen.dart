import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/profile/officials_profile_head.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Official official;

  bool isLoad = true;
  bool isCheck = false;

  List<Feed> feeds = [];

  getFeedData() async {
    FeedService feedService = FeedService();
    feeds = await feedService.getUserFeeds(official.officialsId);
    isLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    official = ModalRoute.of(context).settings.arguments;

    if (!isCheck) {
      isCheck = true;
      getFeedData();
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            OfficialsProfileHead(official),
            isLoad
                ? Loading()
                : Expanded(
                    child: ListView.builder(
                      itemCount: feeds.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return FeedCard(feed: feeds[index],isDetail: false,);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
