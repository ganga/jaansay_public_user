import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NearbyListScreen extends StatefulWidget {
  @override
  _NearbyListScreenState createState() => _NearbyListScreenState();
}

class _NearbyListScreenState extends State<NearbyListScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  FeedService feedService = FeedService();
  List<Feed> feeds = [];
  List<FeedFilter> filterRegion = [];
  List<FeedFilter> filterType = [];
  FeedFilter selectedType, selectedRegion;
  bool isLoad = true;
  bool loadMore = true;
  int page = 1;

  getFeedFilters() async {
    List<FeedFilter> feedFilters = [];

    await feedService.getFeedFilters(feedFilters);

    feedFilters.map((e) {
      if (e.filterType == 'category') {
        if (e.filterId != 1) {
          filterType.add(e);
        }
      } else {
        if (e.filterId != 1) {
          filterRegion.add(e);
        }
      }
    }).toList();
    selectedType = filterType.first;
    selectedRegion = filterRegion.first;
    loadFeeds(true);
  }

  loadFeeds(bool isRefresh) async {
    if (isRefresh) {
      feeds.clear();
      loadMore = true;
      isLoad = true;
      page = 1;
      refreshController.resetNoData();
    } else {
      page++;
    }
    if (loadMore) {
      final response = await feedService.getNearbyFeeds(
          page, selectedRegion.filterId, selectedType.filterId);
      feeds += response[0];
      loadMore = response[1] == null ? false : true;
      refreshController.loadComplete();
      refreshController.refreshCompleted();
    } else {
      refreshController.loadNoData();
    }
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFeedFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade50,
      child: isLoad
          ? CustomLoading()
          : Container(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: ClassicHeader(),
                onRefresh: () => loadFeeds(true),
                onLoading: () => loadFeeds(false),
                controller: refreshController,
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
                                  value: selectedType,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      labelText: 'Type',
                                      labelStyle: TextStyle(
                                          color: Get.theme.primaryColor)),
                                  items: filterType.map((FeedFilter value) {
                                    return DropdownMenuItem<FeedFilter>(
                                      value: value,
                                      child: Text(value.filterName),
                                    );
                                  }).toList(),
                                  onTap: () {
                                    Get.focusScope.unfocus();
                                  },
                                  onChanged: (val) {
                                    selectedType = val;
                                    loadFeeds(true);
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: DropdownButtonFormField<FeedFilter>(
                                  value: selectedRegion,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      labelText: 'Region',
                                      labelStyle: TextStyle(
                                          color: Get.theme.primaryColor)),
                                  items: filterRegion.map((FeedFilter value) {
                                    return DropdownMenuItem<FeedFilter>(
                                      value: value,
                                      child: Text(value.filterName),
                                    );
                                  }).toList(),
                                  onTap: () {
                                    Get.focusScope.unfocus();
                                  },
                                  onChanged: (val) {
                                    selectedRegion = val;
                                    loadFeeds(true);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      feeds.length == 0
                          ? CustomErrorWidget(
                              title: "No feeds",
                              iconData: Icons.dynamic_feed,
                              height: Get.height * 0.6,
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: feeds.length,
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                return FeedCard(
                                  feed: feeds[index],
                                  isDetail: false,
                                  isBusiness: false,
                                  onTap: () {
                                    feeds[index].isLiked = 1;
                                    feeds[index].likes++;
                                    setState(() {});
                                    feedService.likeFeed(feeds[index].feedId,
                                        feeds[index].userId.toString());
                                  },
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
