import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/service/auth_service.dart';
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

  GetStorage box = GetStorage();
  Dio dio = Dio();
  Future<void> addReview(
      String officialId, String rating, String message) async {
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

  Future<void> updateUser(File photo) async {
    Response response =
        await dio.patch("${ConnUtils.url}publicusers/profilephoto",
            data: {
              "user_id": "${box.read("user_id")}",
              "photo": {
                "file_name": "${box.read("user_id")}.png",
                "file": base64Encode(
                  photo.readAsBytesSync(),
                ),
              }
            },
            options: Options(headers: {
              HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
            }));
    print(response.data);
    return;
  }

  Future<bool> createUser() async {
    bool isSuccess = false;
    try {
      Response response = await dio.post(
        "${ConnUtils.url}publicusers",
        data: {
          "user_name": "${box.read("register_name")}",
          "user_gender": "${box.read("register_gender")}",
          "user_dob": "${box.read("register_dob")}",
          "user_pincode": "${box.read("register_pincode")}",
          "user_phone": "${box.read("register_phone")}",
          "photo": "${box.read("register_profile")}",
          "panchayat_id": "${box.read("register_panchayat")}",
          "type_id": "100"
        },
      );
      print(response.data);
      print("${box.read("register_phone")}");
      if (response.data["success"]) {
        AuthService authService = AuthService();
        final response =
            await authService.loginUser("+91${box.read("register_phone")}");
        if (response) {
          print("${box.read("register_panchayat")}");
          isSuccess = true;
        }
      }
      return isSuccess;
    } catch (e) {
      print(e.toString());
      return isSuccess;
    }
  }
}
