class Alert {
  Alert({
    this.alertId,
    this.userId,
    this.alertMessage,
    this.updatedAt,
    this.officialsName,
    this.photo,
    this.typeName,
  });

  int alertId;
  int userId;
  String alertMessage;
  DateTime updatedAt;
  String officialsName;
  String photo;
  String typeName;

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        alertId: json["alert_id"],
        userId: json["user_id"],
        alertMessage: json["alert_message"],
        updatedAt: DateTime.parse(json["updated_at"]),
        officialsName: json["officials_name"],
        photo: json["photo"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "alert_id": alertId,
        "user_id": userId,
        "alert_message": alertMessage,
        "updated_at": updatedAt.toIso8601String(),
        "officials_name": officialsName,
        "photo": photo,
        "type_name": typeName,
      };
}
