import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/alert.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class AlertService {
  Future<List<Alert>> getAllAlerts() async {
    List<Alert> alerts = [];
    GetStorage box = GetStorage();

    String token = box.read("token");
    alerts.clear();
    Dio dio = Dio();

    Response response = await dio.get("${ConnUtils.url}alert",
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

    if (response.data['success']) {
      response.data['data']
          .map((val) => alerts.add(Alert.fromJson(val)))
          .toList();
    } else {
      //TODO empty
    }
    return alerts;
  }
}
