import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/service/follow_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserFeedProvider with ChangeNotifier {
  List<Feed> _feeds = [];
  List<Official> _followReqs = [];
  bool _isLoad = true;
  bool _loadMore = true;
  int page = 1;

  List<Feed> get feeds {
    return [..._feeds];
  }

  List<Official> get followReqs {
    return [..._followReqs];
  }

  bool getLoading() {
    return _isLoad;
  }

  Future getFeedData(RefreshController _refreshController) async {
    _feeds.clear();
    _followReqs.clear();
    FeedService feedService = FeedService();
    _feeds = await feedService.getLastTwoFeeds();
    _followReqs = await feedService.getFollowReqs();
    _refreshController.refreshCompleted();
    _isLoad = false;
    _loadMore = true;
    _refreshController.resetNoData();
    notifyListeners();
    return;
  }

  acceptFollow(Official official) {
    _followReqs.remove(official);
    notifyListeners();
    FollowService followService = FollowService();
    followService.followUser(official.officialsId);
  }

  rejectFollow(Official official) {
    _followReqs.remove(official);
    notifyListeners();
    FollowService followService = FollowService();
    followService.rejectFollow(official.officialsId);
  }

  Future loadMoreFeeds(RefreshController _refreshController) async {
    if (_loadMore) {
      FeedService feedService = FeedService();
      final response = await feedService.getMoreFeeds(page.toString());
      _feeds += response[0];
      _loadMore = response[1] == null ? false : true;
      if (response[1] != null) {
        page = response[1];
      }
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
    notifyListeners();
    return;
  }

  likeFeed(Feed feed) async {
    if (feed.isLiked == 0) {
      FeedService feedService = FeedService();
      _feeds[_feeds.indexOf(feed)].isLiked = 1;
      _feeds[_feeds.indexOf(feed)].likes =
          1 + _feeds[_feeds.indexOf(feed)].likes;
      await feedService.likeFeed(feed.feedId);
      notifyListeners();
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

  removeLocalFollow(Official official) {
    Official tempOfficial;
    _followReqs.forEach((element) {
      if (element.officialsId == official.officialsId) {
        tempOfficial = element;
      }
    });
    if (tempOfficial != null) {
      _followReqs.remove(tempOfficial);
      notifyListeners();
    }
  }
}
