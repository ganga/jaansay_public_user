import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class GrievanceService {
  Future<void> addGrievance({
    String official_id,
    String latitude,
    String longitude,
    String message,
    var files,
  }) async {
    GetStorage box = GetStorage();
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

    Dio dio = Dio();

    Response response = await dio.post("${ConnUtils.url}grievances",
        data: {
          "official_id": "$official_id",
          "user_id": "${box.read("user_id")}",
          "grievance_message": "$message",
          "lattitude": "$latitude",
          "longitude": "$longitude",
          "status_id": "0",
          "updated_at": "${DateTime.now()}",
          "is_feedback": "0",
          "doc_id": "2",
          "media": (_media.length == 0 || _media == null) ? "no media" : _media,
        },
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
        }));
    print(response.data);
  }
}
