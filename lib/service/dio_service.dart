import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/constants/constants.dart';

class DioService {
  GetStorage box = GetStorage();

  Dio dio = new Dio(BaseOptions(headers: {
    HttpHeaders.authorizationHeader: "Bearer ${GetStorage().read("token")}",
  }, baseUrl: Constants.url));

  Future getData(String url,
      {String errorMessage = "Oops something went wrong"}) async {
    try {
      final response = await dio.get(
        url,
      );
      if (response.data["success"] && response.data['data'] != null) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future postData(String url, Map data,
      {String errorMessage = "Oops something went wrong"}) async {
    try {
      final response = await dio.post(url, data: data);
      if (response.data["success"] && response.data['data'] != null) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future postFormData(String url, FormData data,
      {String errorMessage = "Oops something went wrong"}) async {
    try {
      final response = await dio.post(url, data: data);
      if (response.data["success"] && response.data['data'] != null) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future patchData(String url, Map data,
      {String errorMessage = "Oops something went wrong"}) async {
    try {
      final response = await dio.patch(url, data: data);
      if (response.data["success"] && response.data['data'] != null) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future patchFormData(String url, FormData data,
      {String errorMessage = "Oops something went wrong"}) async {
    try {
      final response = await dio.patch(url, data: data);
      if (response.data["success"] && response.data['data'] != null) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future deleteData(String url,
      {Map data = const {},
      String errorMessage = "Oops something went wrong"}) async {
    try {
      final response = await dio.delete(url, data: data);
      if (response.data["success"] && response.data['data'] != null) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
