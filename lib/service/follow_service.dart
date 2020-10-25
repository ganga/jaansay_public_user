import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class FollowService {
  Future<bool> followUser(int officialId) async {
    GetStorage box = GetStorage();

    final token = box.read("token");
    final userId = box.read("user_id");

    Dio dio = Dio();
    Response response = await dio.patch(
      "${ConnUtils.url}follow",
      data: {
        "is_follow": "1",
        "official_id": officialId.toString(),
        "user_id": userId.toString()
      },
      options:
          Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
    );

    if(response.data["success"]){
      FirebaseMessaging fbm=FirebaseMessaging();
      fbm.subscribeToTopic("${officialId}follow");
    }

    print(response.data);

    return true;
  }

  Future<bool> rejectFollow(int officialId) async {
    GetStorage box = GetStorage();

    final token = box.read("token");
    final userId = box.read("user_id");

    Dio dio = Dio();
    Response response = await dio.delete(
      "${ConnUtils.url}follow/${userId}/${officialId}",
      options:
          Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
    );

    print(response.data);

    return true;
  }
}
