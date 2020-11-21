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
    String fileName = box.read("user_name").toString() +
        box.read("user_phone").toString() +
        ".jpg";
    fileName = fileName.replaceAll(new RegExp(r"\s+"), "");
    box.write("photo", "${ConnUtils.photoUrl}$fileName");
    Response response =
        await dio.patch("${ConnUtils.url}publicusers/profilephoto",
            data: {
              "user_id": "${box.read("user_id")}",
              "photo": {
                "file_name": "$fileName",
                "file": base64Encode(
                  photo.readAsBytesSync(),
                ),
              }
            },
            options: Options(headers: {
              HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
            }));
    return;
  }

  Future<bool> createUser() async {
    bool isSuccess = false;
    String fileName = "";
    if (box.read("register_profile") != "no photo") {
      fileName = box.read("register_name").toString() +
          box.read("register_phone").toString() +
          ".jpg";
      fileName = fileName.replaceAll(new RegExp(r"\s+"), "");
    }

    try {
      Response response = await dio.post(
        "${ConnUtils.url}publicusers",
        data: {
          "user_name": "${box.read("register_name")}",
          "user_gender": "${box.read("register_gender")}",
          "user_dob": "${box.read("register_dob")}",
          "user_pincode": "${box.read("register_pincode")}",
          "user_phone": "${box.read("register_phone")}",
          "user_password": "${box.read("register_password")}",
          "photo": fileName == ""
              ? "no photo"
              : {
                  "file_name": "$fileName",
                  "file": "${box.read("register_profile")}",
                },
          "panchayat_id": "${box.read("register_panchayat")}",
          "type_id": "100"
        },
      );
      print(response.data);
      print("${box.read("register_phone")}");
      if (response.data["success"]) {
        AuthService authService = AuthService();
        final response = await authService.loginUser(
            box.read("register_phone"), box.read("register_password"));
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
