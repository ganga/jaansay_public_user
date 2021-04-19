class User {
  User(
      {this.userId,
      this.userName,
      this.userGender,
      this.userDob,
      this.userPincode,
      this.userPhone,
      this.photo,
      this.description,
      this.panchayatName,
      this.typeName,
      this.document,
      this.districtId});

  int userId;
  String userName;
  String userGender;
  String userDob;
  String userPincode;
  String userPhone;
  String photo;
  String description;
  String panchayatName;
  String typeName;
  String document;
  int districtId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: json["user_name"],
        userGender: json["user_gender"],
        userDob: json["user_dob"],
        userPincode: json["user_pincode"],
        userPhone: json["user_phone"],
        photo: json["photo"],
        description: json["description"] == null ? null : json["description"],
        panchayatName: json["panchayat_name"],
        typeName: json["type_name"],
        document: json["user_document"],
        districtId: json['district_id'],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_gender": userGender,
        "user_dob": userDob,
        "user_pincode": userPincode,
        "user_phone": userPhone,
        "photo": photo,
        "description": description == null ? null : description,
        "panchayat_name": panchayatName,
        "type_name": typeName,
        "district_id": districtId
      };
}

class UserPoint {
  UserPoint({
    this.officialsId,
    this.officialsName,
    this.photo,
    this.officialDisplayPhone,
    this.businessTypeName,
    this.score,
  });

  int officialsId;
  String officialsName;
  String photo;
  String officialDisplayPhone;
  String businessTypeName;
  int score;

  factory UserPoint.fromJson(Map<String, dynamic> json) => UserPoint(
        officialsId: json["officials_id"],
        officialsName: json["officials_name"],
        photo: json["photo"],
        officialDisplayPhone: json["official_display_phone"],
        businessTypeName: json["businesstype_name"],
        score: json["score"],
      );
}
