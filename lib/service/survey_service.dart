import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/survey.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class SurveyService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<void> getSurvey(List<Survey> surveys, String surveyId) async {
    final response = await dioService.getData("survey/$surveyId");
    if (response != null) {
      response['data'].map((val) {
        surveys.add(Survey.fromJson(val));
      }).toList();
    }
  }

  Future<void> addSurvey(
      List surveyAnswers, String surveyId, String messageId) async {
    final response = await dioService.postData("survey/answers", {
      'survey_id': surveyId,
      "survey_answers": surveyAnswers,
      "user_id": userId,
      "updated_at": DateTime.now().toString()
    });

    if (response != null) {
      await dioService.deleteData(
        "messages/$messageId",
      );
    }
  }
}
