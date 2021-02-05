import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/grievance_test.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/service/notification_service.dart';

class GrievanceService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<void> addGrievance(
      {String officialId,
      String latitude,
      String longitude,
      String message,
      var files,
      String typename}) async {
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

    final response = await dioService.postData("grievances", {
      "official_id": officialId,
      "user_id": userId,
      "grievance_message": "$message",
      "lattitude": latitude.toString(),
      "longitude": longitude.toString(),
      "status_id": typename == "Business" ? "1" : "4",
      "updated_at": DateTime.now().toString(),
      "is_feedback": "0",
      "doc_id": "2",
      "media": (_media.length == 0 || _media == null) ? "no media" : _media,
    });

    if (response != null) {
      NotificationService notificationService = NotificationService();
      await notificationService.sendNotificationToUser(
          "New Message", "You have received one new message", officialId,{});
    }
  }

  getAllUserGrievances(List<GrievanceTest> grievances) async {
    final response = await dioService.getData("grievances/users/$userId");

    if (response != null) {
      response['data'].map((val) {
        grievances.add(GrievanceTest.fromJson(val));
      }).toList();
    }
  }

  Future<bool> addDocument(var file) async {
    final response = await dioService.patchData("publicusers/document", {
      "user_id": userId,
      "user_document": {
        "file_name": userId,
        "file": base64Encode(
          file.readAsBytesSync(),
        ),
      },
    });

    if (response != null) {
      return true;
    } else {
      return false;
    }
  }
}
