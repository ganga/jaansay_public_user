class AcceptedReferral {
  AcceptedReferral({
    this.raId,
    this.acceptedAt,
    this.userId,
    this.userName,
    this.userPhone,
    this.photo,
    this.description,
    this.referrerDescription,
    this.referrerCost,
    this.officialsId,
    this.officialsName,
    this.officialDisplayPhone,
    this.businesstypeName,
  });

  int raId;
  DateTime acceptedAt;
  int userId;
  String userName;
  String userPhone;
  String photo;
  String description;
  String referrerDescription;
  int referrerCost;
  int officialsId;
  String officialsName;
  String officialDisplayPhone;
  String businesstypeName;

  factory AcceptedReferral.fromJson(Map<String, dynamic> json) =>
      AcceptedReferral(
        raId: json["ra_id"],
        acceptedAt: DateTime.parse(json["accepted_at"]),
        userId: json["user_id"],
        userName: json["user_name"],
        userPhone: json["user_phone"],
        photo: json["photo"],
        description: json["description"],
        referrerDescription: json["referrer_description"],
        referrerCost: json["referrer_cost"],
        officialsId: json["officials_id"],
        officialsName: json["officials_name"],
        officialDisplayPhone: json["official_display_phone"],
        businesstypeName: json["businesstype_name"],
      );
}

class ReferralCode {
  ReferralCode({
    this.officialsId,
    this.officialsName,
    this.officialsPhone,
    this.photo,
    this.description,
    this.referrerCost,
    this.referrerDescription,
    this.referredCost,
    this.referredDescription,
    this.rcId,
    this.rcCode,
    this.userId,
    this.rcUrl,
    this.createdAt,
  });

  int officialsId;
  String officialsName;
  String officialsPhone;
  String photo;
  String description;
  int referrerCost;
  String referrerDescription;
  int referredCost;
  String referredDescription;
  int rcId;
  String rcCode;
  int userId;
  String rcUrl;
  DateTime createdAt;

  factory ReferralCode.fromJson(Map<String, dynamic> json) => ReferralCode(
        officialsId: json["officials_id"],
        officialsName: json["officials_name"],
        officialsPhone: json["officials_phone"],
        photo: json["photo"],
        description: json["description"],
        referrerCost: json["referrer_cost"],
        referrerDescription: json["referrer_description"],
        referredCost: json["referred_cost"],
        referredDescription: json["referred_description"],
        rcId: json["rc_id"],
        rcCode: json["rc_code"],
        userId: json["user_id"],
        rcUrl: json["rc_url"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "officials_id": officialsId,
        "officials_name": officialsName,
        "officials_phone": officialsPhone,
        "photo": photo,
        "description": description,
        "referrer_cost": referrerCost,
        "referrer_description": referrerDescription,
        "referred_cost": referredCost,
        "referred_description": referredDescription,
        "rc_id": rcId,
        "rc_code": rcCode,
        "user_id": userId,
        "rc_url": rcUrl,
        "created_at": createdAt.toIso8601String(),
      };
}

class ReferralMaster {
  ReferralMaster({
    this.rmId,
    this.officialId,
    this.description,
    this.referrerCost,
    this.referrerDescription,
    this.referredCost,
    this.referredDescription,
    this.createdAt,
    this.updatedAt,
  });

  int rmId;
  int officialId;
  String description;
  int referrerCost;
  String referrerDescription;
  int referredCost;
  String referredDescription;
  DateTime createdAt;
  DateTime updatedAt;

  factory ReferralMaster.fromJson(Map<String, dynamic> json) => ReferralMaster(
        rmId: json["rm_id"],
        officialId: json["official_id"],
        description: json["description"],
        referrerCost: json["referrer_cost"],
        referrerDescription: json["referrer_description"],
        referredCost: json["referred_cost"],
        referredDescription: json["referred_description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "rm_id": rmId,
        "official_id": officialId,
        "description": description,
        "referrer_cost": referrerCost,
        "referrer_description": referrerDescription,
        "referred_cost": referredCost,
        "referred_description": referredDescription,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
