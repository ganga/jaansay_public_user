class GrievanceMaster {
  GrievanceMaster({
    this.mmId,
    this.officialsId,
    this.officialsName,
    this.officialsPhone,
    this.photo,
    this.message,
  });

  int mmId;
  int officialsId;
  String officialsName;
  String officialsPhone;
  String photo;
  String message;

  factory GrievanceMaster.fromJson(Map<String, dynamic> json) =>
      GrievanceMaster(
          mmId: json["mm_id"],
          officialsId: json["officials_id"],
          officialsName: json["officials_name"],
          officialsPhone: json["officials_phone"],
          photo: json["photo"],
          message: json['message']);

  Map<String, dynamic> toJson() => {
        "mm_id": mmId,
        "officials_id": officialsId,
        "officials_name": officialsName,
        "officials_phone": officialsPhone,
        "photo": photo,
        'message': message,
      };
}

class Grievance {
  Grievance({
    this.messageId,
    this.mmId,
    this.message,
    this.userId,
    this.updatedAt,
    this.surveyId,
    this.type,
  });

  int messageId;
  int mmId;
  String message;
  int userId;
  DateTime updatedAt;
  int surveyId;
  int type;

  factory Grievance.fromJson(Map<String, dynamic> json) => Grievance(
        messageId: json["message_id"],
        mmId: json["mm_id"],
        message: json["message"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"])
            .add(Duration(hours: 5, minutes: 30)),
        surveyId: json["survey_id"] == null ? null : json["survey_id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "mm_id": mmId,
        "message": message,
        "user_id": userId,
        "updated_at": updatedAt.toIso8601String(),
        "survey_id": surveyId == null ? null : surveyId,
        "type": type,
      };
}
