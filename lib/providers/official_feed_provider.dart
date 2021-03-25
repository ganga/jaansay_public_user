import 'package:flutter/cupertino.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/service/feed_service.dart';

class OfficialFeedProvider with ChangeNotifier {
  List<Feed> _feeds = [];
  bool _isLoad = true;

  List<Feed> get feeds {
    return [..._feeds];
  }

  bool getLoading() {
    return _isLoad;
  }

  getFeedData(Official official) async {
    _feeds.clear();
    _isLoad = true;

    FeedService feedService = FeedService();
    _feeds = await feedService.getUserFeeds(official.officialsId);
    _isLoad = false;
    notifyListeners();
  }

  likeFeed(Feed feed, UserFeedProvider userFeedProvider) async {
    if (feed.isLiked == 0) {
      FeedService feedService = FeedService();
      _feeds[_feeds.indexOf(feed)].isLiked = 1;
      _feeds[_feeds.indexOf(feed)].likes =
          1 + _feeds[_feeds.indexOf(feed)].likes;
      userFeedProvider.likeLocalFeed(feed);
      notifyListeners();

      await feedService.likeFeed(feed.feedId, feed.userId.toString());
    }
  }
}
