import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class OfficialService {
  Future<List<Official>> getAllOfficials(String type) async {
    GetStorage box = GetStorage();

    List<Official> officials = [];
    Dio dio = Dio();
    final response = await dio.get("${ConnUtils.url}officials/type/$type",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}"
        }));

    if (response.data['success']) {
      response.data['data']
          .map(
            (val) => officials.add(
              Official.fromJson(val),
            ),
          )
          .toList();
    } else {}
    return officials;
  }

  List<String> getOfficialTypes(List<Official> officials) {
    List<String> officialTypes = [];

    officials.map((e) {
      if (!officialTypes.contains(e.businesstypeName)) {
        officialTypes.add(e.businesstypeName);
      }
    }).toString();
    print(officialTypes.length);
    return officialTypes;
  }

  List<Official> getOfficialOfType(String type, List<Official> officials) {
    List<Official> tempOfficial = [];

    officials.map((e) {
      if (e.businesstypeName == type) {
        tempOfficial.add(e);
      }
    }).toString();
    return tempOfficial;
  }
}
