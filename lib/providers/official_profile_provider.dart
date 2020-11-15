import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

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

  getData(String type) async {
    _isLoad = true;
    _officials.clear();
    _officialTypes.clear();
    OfficialService officialService = OfficialService();
    _officials = await officialService.getAllOfficialsType(type);
    _officialTypes = officialService.getOfficialTypes(_officials);
    _isLoad = false;
    notifyListeners();
  }

  followUser(Official official) async {
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
      options:
          Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
    );
  }
}
