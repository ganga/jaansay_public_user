// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
// Project imports:
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/service/auth_service.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/service/notification_service.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';

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
    await dioService.postData("ratings", {
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

    await dioService.patchFormData("publicusers/profilephoto", formData);
  }

  Future<bool> createUser(LoginController controller) async {
    GetStorage box = GetStorage();
    print(controller.password);
    print(controller.name);
    bool isSuccess = false;
    String fileName = "";
    if (box.read("register_profile") != "no photo") {
      fileName = box.read("register_name").toString() +
          box.read("register_phone").toString() +
          ".jpg";
      fileName = fileName.replaceAll(new RegExp(r"\s+"), "");
    }

    final formData = FormData.fromMap({
      "user_name": controller.name,
      "user_phone": "${box.read("register_phone")}",
      "user_password": controller.password,
      "district_id": "1",
    });

    if (controller.photo != null) {
      formData.files.add(
        MapEntry(
          "media",
          await MultipartFile.fromFile(
            controller.photo.path,
            filename:
                (DateTime.now().toString() + controller.photo.path.toString())
                    .toString()
                    .replaceAll(" ", ""),
          ),
        ),
      );
    }

    final response = await dioService.postFormData("publicusers", formData);
    if (response != null) {
      AuthService authService = AuthService();
      final response = await authService.loginUser(
          box.read("register_phone"), controller.password);

      if (response) {
        isSuccess = true;
      }
    }
    return isSuccess;
  }

  getPoints(List<UserPoint> userPoints) async {
    final response = await dioService.getData("follow/user/$userId/score");
    if (response != null) {
      response['data']
          .map(
            (val) => userPoints.add(
              UserPoint.fromJson(val),
            ),
          )
          .toList();
    }
  }
}
