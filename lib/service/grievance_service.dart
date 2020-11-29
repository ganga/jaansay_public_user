import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class GrievanceService {
  getGrievanceMasters(List<GrievanceMaster> grievanceMasters) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();
      final userId = box.read("user_id");

      Response response = await dio.get(
        "${ConnUtils.url}grievances/messages/users/$userId",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        response.data['data'].map((val) {
          grievanceMasters.add(GrievanceMaster.fromJson(val));
        }).toList();
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  getAllGrievances(List<Grievance> grievances, String grievanceId) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();

      Response response = await dio.get(
        "${ConnUtils.url}grievances/messages/allmessages/$grievanceId",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        response.data['data'].map((val) {
          grievances.add(Grievance.fromJson(val));
        }).toList();
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  getAllGrievancesUsingOfficialId(
      List<Grievance> grievances, String officialId) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();

      Response response = await dio.get(
        "${ConnUtils.url}grievances/messages/allmessages/official/$officialId/user/${box.read('user_id')}",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        response.data['data'].map((val) {
          grievances.add(Grievance.fromJson(val));
        }).toList();
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<bool> sendMessage(
      String message, GrievanceMaster grievanceMaster) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();
      final userId = box.read("user_id");

      Response response = await dio.post(
        "${ConnUtils.url}grievances/addmessage",
        data: {
          "message": message,
          "official_id": grievanceMaster.officialsId.toString(),
          "user_id": userId.toString(),
          "sender_id": userId.toString()
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendMessageUsingOfficialId(
      String message, String officialId) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();
      final userId = box.read("user_id");

      Response response = await dio.post(
        "${ConnUtils.url}grievances/addmessage",
        data: {
          "message": message,
          "official_id": officialId.toString(),
          "user_id": userId.toString(),
          "sender_id": userId.toString()
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
