import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class MiscService {
  Future<Map> getUsersCount() async {
    Map<String, String> countData = {};

    GetStorage box = GetStorage();
    Dio dio = Dio();
    final response = await dio.get(
      "${ConnUtils.url}utility/getallcount",
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}"
        },
      ),
    );

    if (response.data['success']) {
      countData["user"] = response.data['data'][0][0]['totalUsers'].toString();
      countData["business"] =
          response.data['data'][1][0]['totalBusiness'].toString();
      countData["association"] =
          response.data['data'][2][0]['totalAssociation'].toString();
      countData["entity"] =
          response.data['data'][3][0]['totalEntity'].toString();
    } else {}

    return countData;
  }
}
