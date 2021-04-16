import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserFeedProvider with ChangeNotifier {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  List<Feed> _feeds = [];
  bool _isLoad = true;
  bool _loadMore = true;
  int page = 1;

  List<Feed> get feeds {
    return [..._feeds];
  }

  bool getLoading() {
    return _isLoad;
  }

  Future loadFeeds(bool isRefresh) async {
    if (isRefresh) {
      _feeds.clear();
      _loadMore = true;
      _isLoad = true;
      page = 1;
      refreshController.resetNoData();
    } else {
      page++;
    }
    if (_loadMore) {
      FeedService feedService = FeedService();
      final response = await feedService.getMoreFeeds(page.toString());
      _feeds += response[0];
      _loadMore = response[1] == null ? false : true;
      refreshController.loadComplete();
      refreshController.refreshCompleted();
    } else {
      refreshController.loadNoData();
    }
    _isLoad = false;

    notifyListeners();
    return;
  }

  likeFeed(Feed feed) async {
    if (feed.isLiked == 0) {
      FeedService feedService = FeedService();
      _feeds[_feeds.indexOf(feed)].isLiked = 1;
      _feeds[_feeds.indexOf(feed)].likes =
          1 + _feeds[_feeds.indexOf(feed)].likes;
      notifyListeners();

      await feedService.likeFeed(feed.feedId, feed.userId.toString());
    }
  }

  likeLocalFeed(Feed feed) async {
    _feeds.map((e) {
      if (e.feedId == feed.feedId) {
        _feeds[_feeds.indexOf(e)].isLiked = 1;
        _feeds[_feeds.indexOf(e)].likes = 1 + _feeds[_feeds.indexOf(e)].likes;
        notifyListeners();
      }
    }).toList();
  }
}
