import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class UserService {
  GetStorage box = GetStorage();

  Future<List<User>> getAllUsers() async {
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
}
