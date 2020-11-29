import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/survey.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class SurveyService {
  Future<void> getSurvey(List<Survey> surveys, String surveyId) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();

      Response response = await dio.get(
        "${ConnUtils.url}survey/$surveyId",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        response.data['data'].map((val) {
          surveys.add(Survey.fromJson(val));
        }).toList();
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<void> addSurvey(
      List surveyAnswers, String surveyId, String messageId) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();

      Response response = await dio.post(
        "${ConnUtils.url}survey/answers",
        data: {
          'survey_id': surveyId,
          "survey_answers": surveyAnswers,
          "user_id": box.read("user_id"),
          "updated_at": DateTime.now().toString()
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        Response response = await dio.delete(
          "${ConnUtils.url}messages/$messageId",
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
            },
          ),
        );
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }
}
