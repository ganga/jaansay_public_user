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
