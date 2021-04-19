import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/utils/misc_utils.dart';

class GrievanceService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  getAllDashGrievances(List<Official> officials) async {
    final response = await dioService.getData("grievances/user/$userId");
    if (response != null) {
      response['data']
          .map((val) => officials.add(Official.fromJson(val)))
          .toList();
    }
  }

  getAlLGrievancesByOfficialId(
      List<GrievanceMaster> grievanceMasters, String officialId) async {
    final response = await dioService
        .getData("grievances/official/$officialId/user/$userId");
    if (response != null) {
      response['data']
          .map((val) => grievanceMasters.add(GrievanceMaster.fromJson(val)))
          .toList();
    }
  }

  getAlLGrievancesByMasterId(
      List<GrievanceReply> grievanceReply, String masterId) async {
    final response = await dioService.getData("grievances/reply/$masterId");
    if (response != null) {
      response['data']
          .map((val) => grievanceReply.add(GrievanceReply.fromJson(val)))
          .toList();
    }
  }

  addGrievanceMaster(
      List<File> files, String message, String officialId) async {
    String ticketNumber = MiscUtils.getRandomNumberId(7);
    String shareLink = await createShareLink(ticketNumber);

    final formData = FormData.fromMap({
      "message": message,
      "ticket_number": ticketNumber,
      "user_id": userId,
      "official_id": officialId,
      "is_public": 0,
      "is_closed": 0,
      "link": shareLink,
      "content_type": 1
    });

    for (int i = 0; i < files.length; i++) {
      formData.files.addAll([
        MapEntry(
          "media",
          await MultipartFile.fromFile(
            files[i].path,
            filename: (DateTime.now().toString() +
                    i.toString() +
                    officialId.toString() +
                    files[i].path.toString())
                .toString()
                .replaceAll(" ", ""),
          ),
        ),
      ]);
    }

    await dioService.postFormData("grievances/master", formData);
  }

  addReply(List<File> files, String message, String gmId) async {
    final formData = FormData.fromMap({
      "message": message,
      "user_id": userId,
      "gm_id": gmId,
      "content_type": 1
    });

    for (int i = 0; i < files.length; i++) {
      formData.files.addAll([
        MapEntry(
          "media",
          await MultipartFile.fromFile(
            files[i].path,
            filename: (DateTime.now().toString() +
                    i.toString() +
                    userId.toString() +
                    files[i].path.toString())
                .toString()
                .replaceAll(" ", ""),
          ),
        ),
      ]);
    }

    final response =
        await dioService.postFormData("grievances/reply", formData);

    if (response != null) {
      return true;
    }
    return false;
  }

  Future<String> createShareLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://jaansay.page.link',
      link: Uri.parse('https://www.jaansay.com/grievance?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.dev.jaansay_public_user',
      ),
    );
    final dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
  }
}
