import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/service/notification_service.dart';

class OfficialService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<List<Official>> getAllOfficialsType(
      String type, String districtId) async {
    List<Official> officials = [];

    final response = await dioService
        .getData("officials/type/district/$userId/$type/$districtId");
    if (response != null) {
      response['data']
          .map(
            (val) => officials.add(
              Official.fromJson(val),
            ),
          )
          .toList();
    }
    return officials;
  }

  List<String> getOfficialTypes(List<Official> officials) {
    List<String> officialTypes = [];

    officials.map((e) {
      if (!officialTypes.contains(e.businesstypeName)) {
        officialTypes.add(e.businesstypeName);
      }
    }).toString();
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

  getOfficialRatings(String officialId, List<Review> reviews) async {
    Review userReview;

    final response = await dioService.getData("ratings/$officialId");
    if (response != null) {
      response['data'].map((val) {
        if (val['user_id'].toString() == userId) {
          userReview = Review.fromJson(val);
        } else {
          reviews.add(Review.fromJson(val));
        }
      }).toList();
    }

    return userReview;
  }

  Future<List<Official>> getAllOfficials() async {
    List<Official> officials = [];

    final response = await dioService.getData("officials");
    if (response != null) {
      response.data['data']
          .map(
            (val) => officials.add(
              Official.fromJson(val),
            ),
          )
          .toList();
    }
    return officials;
  }

  Future<Official> getOfficialById(String officialId) async {
    Official official;

    final response = await dioService.getData("officials/$userId/$officialId");
    if (response != null) {
      official = Official.fromJson(response['data']);
    }
    return official;
  }

  getOfficialDocuments(
      List<OfficialDocument> officialDocuments, String officialId) async {
    final response = await dioService
        .getData("documents/alldocuments/official/$officialId/user/$userId");

    if (response != null) {
      response['data'].map((e) {
        officialDocuments.add(OfficialDocument.fromJson(e));
      }).toList();
    }
  }

  addUserDocument(File photo, String officialId, String docId) async {
    String fileName = (GetStorage().read("user_name").toString() +
                GetStorage().read("user_phone").toString() +
                docId +
                officialId)
            .toString() +
        ".jpg";
    fileName = fileName.replaceAll(new RegExp(r"\s+"), "");

    final formData = FormData.fromMap({
      "user_id": userId,
      "official_id": officialId,
      "doc_id": docId,
      "media": await MultipartFile.fromFile(photo.path, filename: fileName),
    });

    final response =
        await dioService.postFormData("documents/adduserdocuments", formData);

    NotificationService notificationService = NotificationService();
    await notificationService.sendNotificationToUser(
        "Document Approval",
        GetStorage().read("user_name") + " has sent document for verification.",
        officialId, {});

    return;
  }

  searchOfficials(String val, List<Official> officials) async {
    final response = await dioService.getData("officials/search/$userId/$val");
    if (response != null) {
      response['data']
          .map((val) => officials.add(Official.fromJson(val)))
          .toList();
    }
  }
}
