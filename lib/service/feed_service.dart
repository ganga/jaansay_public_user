import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class FeedService {
  Future<List<Feed>> getLastTwoFeeds() async {
    List<Feed> feeds = [];
    GetStorage box = GetStorage();

    String token = box.read("token");

    try {
      feeds.clear();
      Dio dio = Dio();

      Response response = await dio.get(
          "${ConnUtils.url}feeds/${box.read("user_id")}/lasttwodaysfeeds",
          options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

      if (response.data['success']) {
        response.data['data']
            .map((val) => feeds.add(Feed.fromJson(val)))
            .toList();
      } else {
        //TODO empty
      }
    } catch (e) {}

    return feeds;
  }

  Future<List<Feed>> getMoreFeeds() async {
    List<Feed> feeds = [];
    GetStorage box = GetStorage();

    String token = box.read("token");

    try {
      feeds.clear();
      Dio dio = Dio();

      Response response = await dio.get(
          "${ConnUtils.url}feeds/${box.read("user_id")}/allfeeds",
          options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

      if (response.data['success']) {
        response.data['data']
            .map((val) => feeds.add(Feed.fromJson(val)))
            .toList();
      } else {
        //TODO empty
      }
    } catch (e) {}

    return feeds;
  }

  likeFeed(String feedId) async {
    GetStorage box = GetStorage();

    final userId = box.read("user_id");
    final token = box.read("token");

    Dio dio = Dio();
    Response response = await dio.post(
      "${ConnUtils.url}feeds/like",
      data: {
        "feed_id": "$feedId",
        "user_id": "$userId",
      },
      options:
          Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
    );

    return true;
  }

  Future<List<Feed>> getUserFeeds(int userId) async {
    List<Feed> feeds = [];
    GetStorage box = GetStorage();

    String token = box.read("token");

    try {
      feeds.clear();
      Dio dio = Dio();

      Response response = await dio.get(
          "${ConnUtils.url}feeds/${box.read("user_id")}/$userId",
          options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

      if (response.data['success']) {
        response.data['data']
            .map((val) => feeds.add(Feed.fromJson(val)))
            .toList();
      } else {
        //TODO empty
      }
    } catch (e) {}

    return feeds;
  }

  Future<List<Official>> getFollowReqs() async {
    List<Official> _officials = [];
    GetStorage box = GetStorage();

    String token = box.read("token");

    try {
      Dio dio = Dio();

      Response response = await dio.get(
          "${ConnUtils.url}follow/followrequests/${box.read("user_id")}",
          options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

      if (response.data['success']) {
        if (response.data['message'] == "All follow requests") {
          response.data['data']
              .map((val) => _officials.add(Official.fromJson(val)))
              .toList();
        }
      } else {
        //TODO empty
      }
    } catch (e) {}

    return _officials;
  }
}
