// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class DynamicFeedDetailScreen extends StatefulWidget {
  final String feedId;

  DynamicFeedDetailScreen(this.feedId);

  @override
  _DynamicFeedDetailScreenState createState() =>
      _DynamicFeedDetailScreenState();
}

class _DynamicFeedDetailScreenState extends State<DynamicFeedDetailScreen> {
  final box = GetStorage();
  FeedService feedService = FeedService();
  bool isLoad = true;
  Feed feed;

  getData() async {
    feed = await feedService.getFeedbyId(widget.feedId);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Post").tr(),
        leading: InkWell(
            onTap: () {
              Get.offAll(HomeScreen());
            },
            child: Icon(Icons.arrow_back_outlined)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await Get.offAll(HomeScreen());
          return false;
        },
        child: isLoad
            ? CustomLoading()
            : Container(
                child: SingleChildScrollView(
                  child: FeedCard(
                    isDetail: true,
                    feed: feed,
                  ),
                ),
              ),
      ),
    );
  }
}
