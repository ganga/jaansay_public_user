import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/misc.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class MiscService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<void> getAllCountDistrict(Map countData) async {
    final response = await dioService.getData("utility/getallcount/1");

    if (response != null) {
      countData["user"] = response['data'][0][0]['totalUsers'].toString();
      countData["business"] =
          response['data'][1][0]['totalBusiness'].toString();
      countData["association"] =
          response['data'][2][0]['totalAssociations'].toString();
      countData["entity"] = response['data'][3][0]['totalEntities'].toString();
    }
  }

  Future<void> addFeedback({
    String message,
    var files,
  }) async {
    List _media = [];
    for (var i = 0; i < files.length; i++) {
      File file = File(files[i].path);
      _media.add(
        {
          "file_name": files[i].name,
          "file": base64Encode(
            file.readAsBytesSync(),
          ),
        },
      );
    }
    await dioService.postData("grievances", {
      "user_id": userId,
      "grievance_message": message,
      "lattitude": "0",
      "longitude": "0",
      "status_id": "0",
      "updated_at": DateTime.now().toString(),
      "is_feedback": "1",
      "doc_id": "2",
      "media": (_media.length == 0 || _media == null) ? "no media" : _media,
    });

    return;
  }

  getCarouselData(List<CarouselData> carouselDataList) async {
    final response = await dioService.getData("utility/carousel");

    if (response != null) {
      response['data'].map((val) {
        carouselDataList.add(CarouselData.fromJson(val));
      }).toList();
    }
  }
}
