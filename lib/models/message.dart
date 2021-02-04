class MessageMaster {
  MessageMaster(
      {this.mmId,
      this.officialsId,
      this.officialsName,
      this.officialsPhone,
      this.photo,
      this.message,
      this.messageType});

  int mmId;
  int officialsId;
  String officialsName;
  String officialsPhone;
  String photo;
  String message;
  int messageType;

  factory MessageMaster.fromJson(Map<String, dynamic> json) => MessageMaster(
      mmId: json["mm_id"],
      officialsId: json["officials_id"],
      officialsName: json["officials_name"],
      officialsPhone: json["officials_phone"],
      photo: json["photo"],
      message: json['message'],
      messageType: json['message_type']);

  Map<String, dynamic> toJson() => {
        "mm_id": mmId,
        "officials_id": officialsId,
        "officials_name": officialsName,
        "officials_phone": officialsPhone,
        "photo": photo,
        'message': message,
      };
}

class Message {
  Message({
    this.messageId,
    this.mmId,
    this.message,
    this.userId,
    this.updatedAt,
    this.surveyId,
    this.type,
    this.messageType,
    this.userName,
    this.photo,
    this.officialsName,
  });

  int messageId;
  int mmId;
  String message;
  int userId;
  DateTime updatedAt;
  String surveyId;
  int type;
  int messageType;
  String userName;
  String photo;
  String officialsName;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        messageId: json["message_id"],
        mmId: json["mm_id"],
        message: json["message"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"])
            .add(Duration(hours: 5, minutes: 30)),
        surveyId:
            json["survey_id"] == null ? null : json['survey_id'].toString(),
        type: json["type"],
        messageType: json["message_type"],
        userName: json["user_name"] == null ? null : json["user_name"],
        photo: json["photo"] == null ? null : json["photo"],
        officialsName:
            json["officials_name"] == null ? null : json["officials_name"],
      );
}
