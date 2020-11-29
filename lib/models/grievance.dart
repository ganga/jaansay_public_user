class GrievanceMaster {
  GrievanceMaster({
    this.gmmId,
    this.officialsId,
    this.officialsName,
    this.officialsPhone,
    this.photo,
    this.message,
  });

  int gmmId;
  int officialsId;
  String officialsName;
  String officialsPhone;
  String photo;
  String message;

  factory GrievanceMaster.fromJson(Map<String, dynamic> json) =>
      GrievanceMaster(
        gmmId: json["gmm_id"],
        officialsId: json["officials_id"],
        officialsName: json["officials_name"],
        officialsPhone: json["officials_phone"],
        photo: json["photo"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "gmm_id": gmmId,
        "officials_id": officialsId,
        "officials_name": officialsName,
        "officials_phone": officialsPhone,
        "photo": photo,
        "message": message,
      };
}

class Grievance {
  Grievance({
    this.messageId,
    this.gmmId,
    this.message,
    this.userId,
    this.updatedAt,
    this.userName,
    this.photo,
    this.officialsName,
  });

  int messageId;
  int gmmId;
  String message;
  int userId;
  DateTime updatedAt;
  dynamic userName;
  String photo;
  String officialsName;

  factory Grievance.fromJson(Map<String, dynamic> json) => Grievance(
        messageId: json["message_id"],
        gmmId: json["gmm_id"],
        message: json["message"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        userName: json["user_name"],
        photo: json["photo"],
        officialsName: json["officials_name"],
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "gmm_id": gmmId,
        "message": message,
        "user_id": userId,
        "updated_at": updatedAt.toIso8601String(),
        "user_name": userName,
        "photo": photo,
        "officials_name": officialsName,
      };
}
