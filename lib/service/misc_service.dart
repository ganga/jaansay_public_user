import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class MiscService {
  Future<void> getAllCount(Map countData, List<Map> districtMap) async {
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
      countData["user"] = response.data['data'][1][0]['totalUsers'].toString();
      countData["business"] =
          response.data['data'][2][0]['totalBusiness'].toString();
      countData["association"] =
          response.data['data'][3][0]['totalAssociations'].toString();
      countData["entity"] =
          response.data['data'][4][0]['totalEntities'].toString();
      response.data['data'][0].map((e) {
        districtMap.add(e);
      }).toList();
    } else {}
    return;
  }

  Future<void> getAllCountDistrict(
      Map countData, List<Map> districtMap, String districtId) async {
    GetStorage box = GetStorage();
    Dio dio = Dio();
    final response = await dio.get(
      "${ConnUtils.url}utility/getallcount/$districtId",
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
          response.data['data'][2][0]['totalAssociations'].toString();
      countData["entity"] =
          response.data['data'][3][0]['totalEntities'].toString();
    } else {}
    return;
  }
}
