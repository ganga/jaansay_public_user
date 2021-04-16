import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';

import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class DynamicFeedDetailScreen extends StatefulWidget {
  @override
  _DynamicFeedDetailScreenState createState() =>
      _DynamicFeedDetailScreenState();
}

class _DynamicFeedDetailScreenState extends State<DynamicFeedDetailScreen> {
  double height = 0, width = 0;
  final box = GetStorage();
  bool isLoad = true;
  Function likeFeedMain;
  String feedId = "";
  bool isCheck = false;
  Feed feed;

  getData() async {
    GetStorage box = GetStorage();

    String token = box.read("token");

    try {
      Dio dio = Dio();

      final response = await dio.get(
          "${Constants.url}feeds/${box.read("user_id")}/allfeeds/$feedId",
          options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

      if (response.data['success']) {
        response.data['data'].map((val) => feed = Feed.fromJson(val)).toList();
      } else {
        //TODO empty
      }
    } catch (e) {}
    isLoad = false;
    setState(() {});
  }

  likeFeed() {
    likeFeedMain();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;
    if (!isCheck) {
      feedId = ModalRoute.of(context).settings.arguments;
      isCheck = true;
      getData();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Post").tr(),
        leading: InkWell(
            onTap: () {
              Get.offAll(HomeScreen());
            },
            child: Icon(Icons.arrow_back_outlined)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await Get.offAll(HomeScreen());
          return false;
        },
        child: isLoad
            ? CustomLoading()
            : Container(
                child: SingleChildScrollView(
                  child: FeedCard(
                    isDetail: true,
                    feed: feed,
                  ),
                ),
              ),
      ),
    );
  }
}
