import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class UserService {
  Future<List<User>> getAllUsers() async {
    GetStorage box = GetStorage();
    List<User> users = [];
    Dio dio = Dio();
    final response = await dio.get("${ConnUtils.url}publicusers",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}"
        }));

    if (response.data['success']) {
      response.data['data']
          .map(
            (val) => users.add(
              User.fromJson(val),
            ),
          )
          .toList();
    } else {}

    return users;
  }

  Future<void> addReview(
      String officialId, String rating, String message) async {
    GetStorage box = GetStorage();

    Dio dio = Dio();

    Response response = await dio.post("${ConnUtils.url}ratings",
        data: {
          "rating": rating,
          "rating_message": message,
          "user_id": "${box.read("user_id")}",
          "official_id": "$officialId",
          "updated_at": "${DateTime.now()}"
        },
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
        }));

    return;
  }
}
