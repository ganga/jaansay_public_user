import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class OfficialService {
  Future<List<Official>> getAllOfficialsType(
      String type, String districtId) async {
    GetStorage box = GetStorage();

    List<Official> officials = [];
    Dio dio = Dio();

    officials.clear();

    try {
      final response = await dio.get(
        "${ConnUtils.url}officials/type/district/${box.read("user_id")}/$type/$districtId",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}"
          },
        ),
      );

      if (response.data['success']) {
        response.data['data']
            .map(
              (val) => officials.add(
                Official.fromJson(val),
              ),
            )
            .toList();
      } else {}
    } catch (e) {}

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

  getOfficialRatings(String officialId) async {
    List<Review> reviews = [];
    GetStorage box = GetStorage();

    final userId = box.read("user_id");
    final token = box.read("token");
    Review userReview;
    try {
      Dio dio = Dio();
      Response response = await dio.get(
        "${ConnUtils.url}ratings/$officialId",
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer ${token}"}),
      );
      if (response.data['success']) {
        if (response.data['data'] != null) {
          response.data['data'].map((val) {
            if (val['user_id'] == userId) {
              userReview = Review.fromJson(val);
            } else {
              reviews.add(Review.fromJson(val));
            }
          }).toList();
        } else {
          //TODO no followers
        }
      } else {
        //TODO
      }
    } catch (e) {}

    return [userReview, reviews];
  }

  Future<List<Official>> getAllOfficials() async {
    GetStorage box = GetStorage();

    List<Official> officials = [];
    Dio dio = Dio();

    officials.clear();
    final response = await dio.get(
      "${ConnUtils.url}officials",
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}"
        },
      ),
    );

    if (response.data['success']) {
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
    GetStorage box = GetStorage();

    Official official;
    Dio dio = Dio();

    final response = await dio.get(
      "${ConnUtils.url}officials/${box.read('user_id')}/$officialId",
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}"
        },
      ),
    );

    if (response.data['success']) {
      official = Official.fromJson(response.data['data']);
    }

    return official;
  }

  getOfficialDocuments(
      List<OfficialDocument> officialDocuments, String officialId) async {
    GetStorage box = GetStorage();

    Official official;
    Dio dio = Dio();

    final response = await dio.get(
      "${ConnUtils.url}documents/alldocuments/official/$officialId/user/${box.read('user_id')}",
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}"
        },
      ),
    );

    print(response.data);
    if (response.data['success']) {
      if (response.data != null) {
        response.data['data'].map((e) {
          officialDocuments.add(OfficialDocument.fromJson(e));
        }).toList();
      }
    }

    return;
  }

  addUserDocument(File photo, String officialId, String docId) async {
    GetStorage box = GetStorage();
    Dio dio = Dio();
    String fileName = (box.read("user_name").toString() +
                box.read("user_phone").toString() +
                docId +
                officialId)
            .toString() +
        ".jpg";
    fileName = fileName.replaceAll(new RegExp(r"\s+"), "");

    final formData = FormData.fromMap({
      "user_id": "${box.read("user_id")}",
      "official_id": officialId,
      "doc_id": docId,
      "media": await MultipartFile.fromFile(photo.path, filename: fileName),
    });
    final response = await dio
        .post("${ConnUtils.url}documents/adduserdocuments",
            data: formData,
            options: Options(headers: {
              HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
            }))
        .catchError((e) {
      print(e.toString());
    });
    await dio.post(
      "https://fcm.googleapis.com/fcm/send",
      data: {
        "notification": {
          "title": "Document Approval",
          "body":
              box.read("user_name") + " has sent document for verification.",
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "icon": "http://jaansay.com/logo.png"
        },
        "to": "/topics/$officialId"
      },
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader:
              "key=AAAAvyUrLIs:APA91bE8YAhAlWSGKVxOQnj1747vxLecE4ABRSh2ZpatGjp00rCLiQLUMaT6iyiijDyR5RLmiWxZeZ2-SdkGCSRK9NV0ZI_6AFVWMSGr7E3jk4dGEOfJ4sxmyWibiOA_msRIBVB2I1te",
        },
      ),
    );
    print(response.data);
    return;
  }
}
