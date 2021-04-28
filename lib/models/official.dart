class Official {
  Official(
      {this.officialsId,
      this.officialsName,
      this.officialsDescription,
      this.officialsEmail,
      this.officialsPhone,
      this.officialsDesignation,
      this.lattitude,
      this.longitude,
      this.officialsAddress,
      this.officialsWebsite,
      this.businessHours,
      this.photo,
      this.averageRating,
      this.totalRating,
      this.typeName,
      this.businesstypeName,
      this.isFollow,
      this.isRating,
      this.isPrivate,
      this.isCatalog,
      this.isReferral,
      this.detailDescription,
      this.officialDisplayPhone,
      this.kmId,
      this.profileLink});

  int officialsId;
  String officialsName;
  String officialsDescription;
  String officialsEmail;
  String officialsPhone;
  String officialDisplayPhone;
  String officialsDesignation;
  String lattitude;
  String longitude;
  String officialsAddress;
  String officialsWebsite;
  String businessHours;
  String photo;
  double averageRating;
  int totalRating;
  String typeName;
  String businesstypeName;
  int isFollow;
  int isRating;
  int isPrivate;
  int isCatalog;
  int isReferral;
  String detailDescription;
  int kmId;
  String profileLink;

  factory Official.fromJson(Map<String, dynamic> json) => Official(
      officialsId: json["officials_id"],
      officialsName: json["officials_name"],
      officialsDescription: json["officials_description"],
      officialsEmail: json["officials_email"],
      officialsPhone: json["officials_phone"],
      officialsDesignation: json["officials_designation"],
      lattitude: json["lattitude"],
      longitude: json["longitude"],
      officialsAddress: json["officials_address"],
      officialsWebsite: json["officials_website"],
      businessHours: json["business_hours"],
      photo: json["photo"],
      averageRating: json["average_rating"] == null
          ? 0
          : json["average_rating"].toDouble(),
      totalRating: json["total_rating"],
      typeName: json["type_name"],
      businesstypeName: json["businesstype_name"],
      isFollow: json["is_follow"] == null ? 0 : json["is_follow"],
      isRating: json["is_rating"],
      isPrivate: json['is_private'],
      isCatalog: json['cc_id'] == null ? 0 : 1,
      isReferral: json["rm_id"],
      detailDescription:
          json["detail_description"] == null ? '' : json["detail_description"],
      officialDisplayPhone: json["official_display_phone"] == null
          ? ''
          : json["official_display_phone"],
      kmId: json["km_id"],
      profileLink: json['profile_link']);

  factory Official.fromGrievanceJson(Map<String, dynamic> json) => Official(
        officialsId: json["officials_id"],
        officialsName: json["officials_name"],
        photo: json["photo"],
        typeName: json["type_name"],
        officialDisplayPhone: json["official_display_phone"],
      );

  factory Official.fromFeedbackSurveyJson(Map<String, dynamic> json) =>
      Official(
          officialsId: json["officials_id"],
          officialsName: json["officials_name"],
          photo: json["photo"],
          typeName: json["type_name"],
          officialDisplayPhone: json["official_display_phone"],
          kmId: int.parse(json['is_feedback']));
}

class OfficialDocument {
  OfficialDocument({
    this.dorId,
    this.docId,
    this.officialId,
    this.docName,
    this.isDocument,
    this.isVerified,
  });

  int dorId;
  int docId;
  int officialId;
  String docName;
  int isDocument;
  int isVerified;

  factory OfficialDocument.fromJson(Map<String, dynamic> json) =>
      OfficialDocument(
        dorId: json["dor_id"],
        docId: json["doc_id"],
        officialId: json["official_id"],
        docName: json["doc_name"],
        isDocument: json["is_document"],
        isVerified: json["is_verified"] == null ? 0 : json["is_verified"],
      );

  Map<String, dynamic> toJson() => {
        "dor_id": dorId,
        "doc_id": docId,
        "official_id": officialId,
        "doc_name": docName,
        "is_document": isDocument,
        "is_verified": isVerified == null ? null : isVerified,
      };
}

class OfficialUtility {
  OfficialUtility({
    this.utilityId,
    this.utilityName,
  });

  int utilityId;
  String utilityName;

  factory OfficialUtility.fromJson(Map<String, dynamic> json) =>
      OfficialUtility(
        utilityId: json["utility_id"],
        utilityName: json["utility_name"],
      );
}

class OfficialType {
  int typeId;
  String typeName;

  OfficialType({this.typeId, this.typeName});
}
