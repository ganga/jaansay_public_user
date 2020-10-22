import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class VocalforlocalService {
  Future<void> addStore({
    String shopName,
    String phone,
    String latitude,
    String longitude,
  }) async {
    GetStorage box = GetStorage();

    Dio dio = Dio();

    Response response = await dio.post("${ConnUtils.url}vocalforlocal",
        data: {
          "user_id": "${box.read("user_id")}",
          "shop_name": shopName,
          "phone": phone,
          "lattitude": latitude,
          "longitude": longitude
        },
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
        }));
    print(response.data);
  }
}
