import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/service/follow_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/feed/feed_list_top.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  bool isLoad = true;
  bool isFollowLoad = true;

  List<Feed> feeds = [];
  List<Official> followReqs = [];

  bool loadMore = true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController _followController =
      RefreshController(initialRefresh: false);

  followList(Size size) {
    return followReqs.length == 0
        ? SizedBox.shrink()
        : Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    "People near you",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: PageScrollPhysics(),
                    itemCount: followReqs.length,
                    itemBuilder: (_, index) {
                      return FeedListTop(
                          size, followReqs[index], followUser, rejectFollow);
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
    feeds.clear();
    followReqs.clear();
    FeedService feedService = FeedService();
    feeds = await feedService.getLastTwoFeeds();
    followReqs = await feedService.getFollowReqs();
    _refreshController.refreshCompleted();
    isLoad = false;
    loadMore = true;
    _refreshController.resetNoData();
    setState(() {});
  }

  loadMoreFeeds() async {
    if (loadMore) {
      FeedService feedService = FeedService();
      feeds = feeds + await feedService.getMoreFeeds();
      _refreshController.loadComplete();
      loadMore = false;
      setState(() {});
    } else {
      _refreshController.loadNoData();
    }
  }

  followUser(Official official) {
    followReqs.remove(official);
    setState(() {});
    FollowService followService = FollowService();
    followService.followUser(official.officialsId);
  }

  rejectFollow(Official official) {
    followReqs.remove(official);
    setState(() {});
    FollowService followService = FollowService();
    followService.rejectFollow(official.officialsId);
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

    return isLoad
        ? Loading()
        : Container(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: ClassicHeader(),
              onRefresh: getFeedData,
              onLoading: loadMoreFeeds,
              controller: _refreshController,
              child: feeds.length == 0
                  ? Column(
                      children: [
                        followList(_mediaQuery),
                        Expanded(
                          child: CustomErrorWidget(
                            title: 'No feeds',
                            iconData: MdiIcons.nullIcon,
                          ),
                        )
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: feeds.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return index == 0
                            ? followList(_mediaQuery)
                            : FeedCard(feeds[index - 1]);
                      }),
            ),
          );
  }
}
