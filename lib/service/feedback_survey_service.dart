// Package imports:
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/survey.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class FeedbackSurveyService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  getSurveyMasters(List<SurveyMaster> surveyMasters, String officialId) async {
    final response =
        await dioService.getData("survey/official/$officialId/user/$userId");
    if (response != null) {
      response['data'].map((val) {
        surveyMasters.add(SurveyMaster.fromJson(val));
      }).toList();
    }
  }

  Future<void> getSurvey(List<Survey> surveys, String surveyId) async {
    final response = await dioService.getData("survey/$surveyId/user/$userId");
    if (response != null) {
      response['data'].map((val) {
        surveys.add(Survey.fromJson(val));
      }).toList();
    }
  }

  Future<void> addSurvey(
      List<SurveyAnswer> surveyAnswers, String surveyId) async {
    await dioService.postData("survey/answers", {
      'survey_id': surveyId,
      "survey_answers": surveyAnswers
          .map((e) => {"sq_id": e.questionId, "so_id": e.answerId})
          .toList(),
      "user_id": userId,
      "updated_at": DateTime.now().toString()
    });
  }

  getDashFeedbackSurvey(List<Official> officials) async {
    final response =
        await dioService.getData("utility/feedback/survey/user/$userId");
    if (response != null) {
      response['data'].map((val) {
        officials.add(Official.fromFeedbackSurveyJson(val));
      }).toList();
    }
  }

  getFeedbackByOfficialId(
      List<FeedbackMaster> feedbackList, String officialId) async {
    final response =
        await dioService.getData("feedback/official/$officialId/user/$userId");
    if (response != null) {
      response['data'].map((val) {
        feedbackList.add(FeedbackMaster.fromJson(val));
      }).toList();
    }
  }

  addFeedback(String feedbackId, String message) async {
    await dioService
        .postData("feedback/answer", {"fu_id": feedbackId, "message": message});
  }
}
