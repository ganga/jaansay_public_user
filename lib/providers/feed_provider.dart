// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/feed_service.dart';

class FeedProvider extends ChangeNotifier {
  FeedService feedService = FeedService();

  RefreshController mainRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController nearbyRefreshController =
      RefreshController(initialRefresh: false);

  List<Feed> mainFeeds = [], businessFeeds = [], nearbyFeeds = [];
  List<FeedFilter> filterRegion = [], filterType = [];

  FeedFilter selectedType, selectedRegion;

  bool isMainLoad = true, isBusinessLoad = true, isNearbyLoad = true;
  bool mainLoadMore = true, nearbyLoadMore = true;
  bool initMainFeed = false, initNearbyFeed = false;

  int mainPage = 1, nearbyPage = 1;

  loadMainFeeds(bool isRefresh) async {
    if (isRefresh) {
      mainFeeds.clear();
      mainLoadMore = true;
      isMainLoad = true;
      mainPage = 1;
      mainRefreshController.resetNoData();
    } else {
      mainPage++;
    }
    if (mainLoadMore) {
      final response = await feedService.getMoreFeeds(mainPage.toString());
      mainFeeds += response[0];
      mainLoadMore = response[1] == null ? false : true;
      mainRefreshController.loadComplete();
      mainRefreshController.refreshCompleted();
    } else {
      mainRefreshController.loadNoData();
    }
    isMainLoad = false;
    notifyListeners();
  }

  loadNearbyFeeds(bool isRefresh) async {
    if (isRefresh) {
      nearbyFeeds.clear();
      nearbyLoadMore = true;
      isNearbyLoad = true;
      nearbyPage = 1;
      nearbyRefreshController.resetNoData();
    } else {
      nearbyPage++;
    }
    if (nearbyLoadMore) {
      final response = await feedService.getNearbyFeeds(
          nearbyPage, selectedRegion.filterId, selectedType.filterId);
      nearbyFeeds += response[0];
      nearbyLoadMore = response[1] == null ? false : true;
      nearbyRefreshController.loadComplete();
      nearbyRefreshController.refreshCompleted();
    } else {
      nearbyRefreshController.loadNoData();
    }
    isNearbyLoad = false;
    notifyListeners();
  }

  loadBusinessFeeds(Official official) async {
    businessFeeds.clear();
    isBusinessLoad = true;
    businessFeeds = await feedService.getUserFeeds(official.officialsId);
    isBusinessLoad = false;
    notifyListeners();
  }

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
    loadNearbyFeeds(true);
  }

  likeFeed(Feed feed) async {
    if (feed.isLiked == 0) {
      likeLocalFeed(feed);
      await feedService.likeFeed(feed.feedId, feed.userId.toString());
    }
  }

  likeLocalFeed(Feed feed) async {
    mainFeeds.map((e) {
      if (e.feedId == feed.feedId) {
        mainFeeds[mainFeeds.indexOf(e)].isLiked = 1;
        mainFeeds[mainFeeds.indexOf(e)].likes =
            1 + mainFeeds[mainFeeds.indexOf(e)].likes;
      }
    }).toList();
    businessFeeds.map((e) {
      if (e.feedId == feed.feedId) {
        businessFeeds[businessFeeds.indexOf(e)].isLiked = 1;
        businessFeeds[businessFeeds.indexOf(e)].likes =
            1 + businessFeeds[businessFeeds.indexOf(e)].likes;
      }
    }).toList();
    nearbyFeeds.map((e) {
      if (e.feedId == feed.feedId) {
        nearbyFeeds[nearbyFeeds.indexOf(e)].isLiked = 1;
        nearbyFeeds[nearbyFeeds.indexOf(e)].likes =
            1 + nearbyFeeds[nearbyFeeds.indexOf(e)].likes;
      }
    }).toList();
    notifyListeners();
  }
}
