// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import 'package:jaansay_public_user/providers/feed_provider.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class FeedListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);

    if (!feedProvider.initMainFeed) {
      feedProvider.initMainFeed = true;
      feedProvider.loadMainFeeds(true);
    }

    return Container(
      color: Colors.blueGrey.shade50,
      child: feedProvider.isMainLoad
          ? CustomLoading()
          : Container(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: ClassicHeader(),
                onRefresh: () => feedProvider.loadMainFeeds(true),
                onLoading: () => feedProvider.loadMainFeeds(false),
                controller: feedProvider.mainRefreshController,
                child: feedProvider.mainFeeds.length == 0
                    ? Expanded(
                        child: CustomErrorWidget(
                          title: "${tr("No feeds")}",
                          iconData: MdiIcons.nullIcon,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: feedProvider.mainFeeds.length,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return FeedCard(
                            feed: feedProvider.mainFeeds[index],
                            isDetail: false,
                          );
                        }),
              ),
            ),
    );
  }
}
