import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/service/auth_service.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/service/notification_service.dart';

class UserService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  getAllUsers(String districtId, List<User> users) async {
    final response =
        await dioService.getData("publicusers/district/$districtId");

    if (response != null) {
      response['data']
          .map(
            (val) => users.add(
              User.fromJson(val),
            ),
          )
          .toList();
    }
  }

  Future<void> addReview(
      String officialId, String rating, String message) async {
    final response = await dioService.postData("ratings", {
      "rating": rating,
      "rating_message": message,
      "user_id": userId,
      "official_id": "$officialId",
      "updated_at": "${DateTime.now()}"
    });
    NotificationService notificationService = NotificationService();
    await notificationService.sendNotificationToUser(
        GetStorage().read("user_name") + " has rated $rating stars",
        message,
        officialId.toString(),
        {"type": "rating"});
  }

  Future<void> updateUser(File photo) async {
    String fileName = GetStorage().read("user_name").toString() +
        GetStorage().read("user_phone").toString() +
        ".jpg";
    fileName = fileName.replaceAll(new RegExp(r"\s+"), "");
    GetStorage().write("photo", "${Constants.photoUrl}$fileName");
    final formData = FormData.fromMap({
      "user_id": userId,
      "media": await MultipartFile.fromFile(photo.path, filename: fileName),
    });
    final response =
        await dioService.patchFormData("publicusers/profilephoto", formData);
  }

  Future<bool> createUser() async {
    GetStorage box = GetStorage();

    bool isSuccess = false;
    String fileName = "";
    if (box.read("register_profile") != "no photo") {
      fileName = box.read("register_name").toString() +
          box.read("register_phone").toString() +
          ".jpg";
      fileName = fileName.replaceAll(new RegExp(r"\s+"), "");
    }

    final response = await dioService.postData("publicusers", {
      "user_name": "${box.read("register_name")}",
      "user_gender": "${box.read("register_gender")}",
      "user_dob": "${box.read("register_dob")}",
      "user_pincode": "${box.read("register_pincode")}",
      "user_phone": "${box.read("register_phone")}",
      "user_password": "${box.read("register_password")}",
      "district_id": "${box.read("register_district")}",
      "photo": fileName == ""
          ? "no photo"
          : {
              "file_name": "$fileName",
              "file": "${box.read("register_profile")}",
            },
      "panchayat_id": "${box.read("register_panchayat")}",
      "type_id": "100"
    });
    if (response != null) {
      AuthService authService = AuthService();
      final response = await authService.loginUser(
          box.read("register_phone"), box.read("register_password"));

      if (response) {
        isSuccess = true;
      }
    }
    return isSuccess;
  }
}
