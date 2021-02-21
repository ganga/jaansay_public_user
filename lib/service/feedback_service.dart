import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class FeedbackService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

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
}
