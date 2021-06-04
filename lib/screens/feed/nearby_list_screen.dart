// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/providers/feed_provider.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class NearbyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);

    if (!feedProvider.initNearbyFeed) {
      feedProvider.initNearbyFeed = true;
      feedProvider.getFeedFilters();
    }

    return Container(
      color: Colors.blueGrey.shade50,
      child: feedProvider.isNearbyLoad
          ? CustomLoading()
          : Container(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: ClassicHeader(),
                onRefresh: () => feedProvider.loadNearbyFeeds(true),
                onLoading: () => feedProvider.loadNearbyFeeds(false),
                controller: feedProvider.nearbyRefreshController,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<FeedFilter>(
                                  value: feedProvider.selectedType,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      labelText: 'Type',
                                      labelStyle: TextStyle(
                                          color: Get.theme.primaryColor)),
                                  items: feedProvider.filterType
                                      .map((FeedFilter value) {
                                    return DropdownMenuItem<FeedFilter>(
                                      value: value,
                                      child: Text(value.filterName),
                                    );
                                  }).toList(),
                                  onTap: () {
                                    Get.focusScope.unfocus();
                                  },
                                  onChanged: (val) {
                                    feedProvider.selectedType = val;
                                    feedProvider.loadNearbyFeeds(true);
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: DropdownButtonFormField<FeedFilter>(
                                  value: feedProvider.selectedRegion,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      labelText: 'Region',
                                      labelStyle: TextStyle(
                                          color: Get.theme.primaryColor)),
                                  items: feedProvider.filterRegion
                                      .map((FeedFilter value) {
                                    return DropdownMenuItem<FeedFilter>(
                                      value: value,
                                      child: Text(value.filterName),
                                    );
                                  }).toList(),
                                  onTap: () {
                                    Get.focusScope.unfocus();
                                  },
                                  onChanged: (val) {
                                    feedProvider.selectedRegion = val;
                                    feedProvider.loadNearbyFeeds(true);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      feedProvider.nearbyFeeds.length == 0
                          ? CustomErrorWidget(
                              title: "No feeds",
                              iconData: Icons.dynamic_feed,
                              height: Get.height * 0.6,
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: feedProvider.nearbyFeeds.length,
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                return FeedCard(
                                  feed: feedProvider.nearbyFeeds[index],
                                  isDetail: false,
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
