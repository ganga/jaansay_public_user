import 'package:flutter/material.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/feed/feed_list_top.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:easy_localization/easy_localization.dart';

class FeedList extends StatelessWidget {
  bool _isCheck = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  UserFeedProvider feedProvider;

  followList() {
    return feedProvider.followReqs.length == 0
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
                  ).tr(),
                ),
                Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: PageScrollPhysics(),
                    itemCount: feedProvider.followReqs.length,
                    itemBuilder: (_, index) {
                      return FeedListTop(feedProvider.followReqs[index]);
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

  @override
  Widget build(BuildContext context) {
    feedProvider = Provider.of<UserFeedProvider>(context);

    if (!_isCheck) {
      _isCheck = true;
      feedProvider.getFeedData(_refreshController);
    }

    return feedProvider.getLoading()
        ? Loading()
        : Container(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: ClassicHeader(),
              onRefresh: () => feedProvider.getFeedData(_refreshController),
              onLoading: () => feedProvider.loadMoreFeeds(_refreshController),
              controller: _refreshController,
              child: feedProvider.feeds.length == 0
                  ? Column(
                      children: [
                        followList(),
                        Expanded(
                          child: CustomErrorWidget(
                            title: "No feeds",
                            iconData: MdiIcons.nullIcon,
                          ),
                        )
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: feedProvider.feeds.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return index == 0
                            ? followList()
                            : FeedCard(
                                feed: feedProvider.feeds[index - 1],
                                isDetail: false,
                                isBusiness: false,
                              );
                      }),
            ),
          );
  }
}
