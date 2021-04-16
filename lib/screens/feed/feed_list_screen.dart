import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedListScreen extends StatelessWidget {
  bool _isCheck = false;

  @override
  Widget build(BuildContext context) {
    UserFeedProvider feedProvider = Provider.of<UserFeedProvider>(context);

    if (!_isCheck) {
      _isCheck = true;
      feedProvider.loadFeeds(true);
    }

    return feedProvider.getLoading()
        ? CustomLoading()
        : Container(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: ClassicHeader(),
              onRefresh: () => feedProvider.loadFeeds(true),
              onLoading: () => feedProvider.loadFeeds(false),
              controller: feedProvider.refreshController,
              child: feedProvider.feeds.length == 0
                  ? Expanded(
                      child: CustomErrorWidget(
                        title: "${tr("No feeds")}",
                        iconData: MdiIcons.nullIcon,
                      ),
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
