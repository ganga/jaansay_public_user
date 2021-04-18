class SurveyMaster {
  SurveyMaster({
    this.surveyId,
    this.surveyTitle,
    this.surveyDescription,
    this.updatedAt,
    this.saId,
  });

  int surveyId;
  String surveyTitle;
  String surveyDescription;
  DateTime updatedAt;
  int saId;

  factory SurveyMaster.fromJson(Map<String, dynamic> json) => SurveyMaster(
        surveyId: json["survey_id"],
        surveyTitle: json["survey_title"],
        surveyDescription: json["survey_description"],
        updatedAt: DateTime.parse(json["updated_at"]),
        saId: json["sa_id"] == null ? null : json["sa_id"],
      );
}

class Survey {
  Survey({
    this.sqId,
    this.surveyId,
    this.sqQuestion,
    this.soId,
    this.soOption,
  });

  int sqId;
  int surveyId;
  String sqQuestion;
  List soId;
  List soOption;

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        sqId: json["sq_id"],
        surveyId: json["survey_id"],
        sqQuestion: json["sq_question"],
        soId: json["so_id"].toString().split(",").toList(),
        soOption: json["so_option"].toString().split(",").toList(),
      );

  Map<String, dynamic> toJson() => {
        "sq_id": sqId,
        "survey_id": surveyId,
        "sq_question": sqQuestion,
        "so_id": soId,
        "so_option": soOption,
      };
}

class FeedbackMaster {
  FeedbackMaster({
    this.id,
    this.officialId,
    this.message,
    this.createdAt,
    this.mediaUrls,
    this.contentTypes,
    this.answer,
  });

  int id;
  int officialId;
  String message;
  DateTime createdAt;
  List<String> mediaUrls;
  String contentTypes;
  String answer;

  factory FeedbackMaster.fromJson(Map<String, dynamic> json) => FeedbackMaster(
        id: json["id"],
        officialId: json["official_id"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        mediaUrls: json["media_urls"] == null
            ? []
            : json["media_urls"].toString().split(","),
        contentTypes:
            json["content_types"] == null ? null : json["content_types"],
        answer: json["answer"],
      );
}
