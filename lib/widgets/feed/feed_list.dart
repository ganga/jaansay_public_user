import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedList extends StatelessWidget {
  bool _isCheck = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    UserFeedProvider feedProvider = Provider.of<UserFeedProvider>(context);

    if (!_isCheck) {
      _isCheck = true;
      feedProvider.loadFeeds(_refreshController, true);
    }

    return feedProvider.getLoading()
        ? Loading()
        : Container(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: ClassicHeader(),
              onRefresh: () => feedProvider.loadFeeds(_refreshController, true),
              onLoading: () =>
                  feedProvider.loadFeeds(_refreshController, false),
              controller: _refreshController,
              child: feedProvider.feeds.length == 0
                  ? Column(
                      children: [
                        Expanded(
                          child: CustomErrorWidget(
                            title: "${tr("No feeds")}",
                            iconData: MdiIcons.nullIcon,
                          ),
                        )
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: feedProvider.feeds.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return FeedCard(
                          feed: feedProvider.feeds[index],
                          isDetail: false,
                          isBusiness: false,
                        );
                      }),
            ),
          );
  }
}
