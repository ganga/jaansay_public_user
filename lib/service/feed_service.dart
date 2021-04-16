import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/service/notification_service.dart';

class FeedService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<List<Feed>> getLastTwoFeeds() async {
    List<Feed> feeds = [];
    final response = await dioService.getData("feeds/$userId/lasttwodaysfeeds");
    if (response != null) {
      response['data'].map((val) => feeds.add(Feed.fromJson(val))).toList();
    }
    return feeds;
  }

  Future<List> getMoreFeeds(String page) async {
    List<Feed> feeds = [];

    final response =
        await dioService.getData("feeds/$userId/allfeeds/page/$page");
    if (response != null) {
      response['data'].map((val) => feeds.add(Feed.fromJson(val))).toList();
      if (response['next'] != null) {
        return [feeds, response['next']['page']];
      }
    }
    return [feeds, null];
  }

  likeFeed(String feedId, String officialId) async {
    await dioService.postData("feeds/like", {
      "feed_id": feedId,
      "user_id": userId,
    });

    NotificationService notificationService = NotificationService();
    await notificationService.sendNotificationToUser(
        "You got a new like!",
        "${GetStorage().read("user_name").toString()} has liked your post.",
        officialId.toString(),
        {"type": "like"});
  }

  getFeedbyId(String feedId) async {
    final response = await dioService.getData("feeds/$userId/allfeeds/$feedId");

    if (response != null) {
      return Feed.fromJson(response['data'][0]);
    } else {
      return null;
    }
  }

  Future<List<Feed>> getUserFeeds(int officialId) async {
    List<Feed> feeds = [];

    await dioService.postData("profilevisitors", {
      "user_id": userId,
      "official_id": officialId.toString(),
      "updated_at": "${DateTime.now()}"
    });

    final response = await dioService.getData("feeds/$userId/$officialId");

    if (response != null) {
      response['data'].map((val) => feeds.add(Feed.fromJson(val))).toList();
    }

    return feeds;
  }

  Future<List<Official>> getFollowReqs() async {
    List<Official> _officials = [];

    final response = await dioService.getData("follow/followrequests/$userId");
    if (response != null) {
      if (response['message'] == "All follow requests") {
        response['data']
            .map((val) => _officials.add(Official.fromJson(val)))
            .toList();
      }
    }

    return _officials;
  }
}
