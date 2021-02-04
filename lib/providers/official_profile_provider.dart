import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/service/follow_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';
import 'package:jaansay_public_user/utils/search_utils.dart';

class OfficialProfileProvider with ChangeNotifier {
  bool _isLoad = true;

  List<Official> _officials = [];
  List<String> _officialTypes = [];

  bool get isLoad {
    return _isLoad;
  }

  List<Official> get officials {
    return [..._officials];
  }

  List<String> get officialTypes {
    return [..._officialTypes];
  }

  getData(String type, String districtId) async {
    _isLoad = true;
    _officials.clear();
    _officialTypes.clear();
    OfficialService officialService = OfficialService();
    _officials = await officialService.getAllOfficialsType(type, districtId);
    _officialTypes = officialService.getOfficialTypes(_officials);
    _isLoad = false;
    notifyListeners();
  }

  getOfficialById(String officialId) async {
    _isLoad = true;
    _officials.clear();
    _officialTypes.clear();
    OfficialService officialService = OfficialService();
    _officials.add(await officialService.getOfficialById(officialId));
    _officialTypes = officialService.getOfficialTypes(_officials);
    _isLoad = false;
    notifyListeners();
  }

  searchOfficial(String val) async {
    if (val.length > 2) {
      SearchUtils searchUtils = SearchUtils();
      _isLoad = true;

      _officials.clear();
      await searchUtils.searchUsers(val, _officials);
      _officials.removeWhere(
          (element) => (element.isPrivate == 1 && element.isFollow != 1));
      _isLoad = false;
      notifyListeners();
    }
  }

  followUser(Official official, UserFeedProvider userFeedProvider) async {
    if (official.isFollow != null && official.isFollow == 0) {
      _officials[_officials.indexOf(official)].isFollow = 1;
      notifyListeners();
      userFeedProvider.removeLocalFollow(official);

      FollowService followService = FollowService();
      followService.followUser(official.officialsId);
      notifyListeners();
    } else {
      _officials[_officials.indexOf(official)].isFollow = 1;
      notifyListeners();

      GetStorage box = GetStorage();
      final userId = box.read("user_id");
      final token = box.read("token");

      Dio dio = Dio();
      Response response = await dio.post(
        "${ConnUtils.url}follow",
        data: {
          "official_id": "${official.officialsId}",
          "user_id": "$userId",
          "is_follow": "1",
          "updated_at": "${DateTime.now()}"
        },
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
      );
      notifyListeners();
    }
  }
}
