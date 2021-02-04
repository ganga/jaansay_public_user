import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class SearchUtils {
  Future<List<Official>> searchUsers(
      String val, List<Official> officials) async {
    GetStorage box = GetStorage();

    String token = box.read("token");

    Dio dio = Dio();

    Response response = await dio.get(
        "${ConnUtils.url}officials/search/${box.read("user_id")}/$val",
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));

    if (response.data['success']) {
      print(response.data);
      response.data['data']
          .map((val) => officials.add(Official.fromJson(val)))
          .toList();
    } else {
      //TODO empty
    }
  }
}
