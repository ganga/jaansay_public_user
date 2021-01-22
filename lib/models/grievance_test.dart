class GrievanceTest {
  GrievanceTest({
    this.grievanceId,
    this.grievanceMessage,
    this.statusId,
    this.lattitude,
    this.longitude,
    this.updatedAt,
    this.officialsId,
    this.officialsName,
    this.officialsDescription,
    this.officialsEmail,
    this.officialsPhone,
    this.officialsDesignation,
    this.officialsAddress,
    this.officialsWebsite,
    this.businessHours,
    this.photo,
    this.typeName,
    this.businesstypeName,
    this.media,
    this.docId,
  });

  String grievanceId;
  String grievanceMessage;
  int statusId;
  String lattitude;
  String longitude;
  String updatedAt;
  int officialsId;
  String officialsName;
  String officialsDescription;
  String officialsEmail;
  String officialsPhone;
  String officialsDesignation;
  String officialsAddress;
  String officialsWebsite;
  String businessHours;
  String photo;
  String typeName;
  String businesstypeName;
  dynamic media;
  dynamic docId;

  factory GrievanceTest.fromJson(Map<String, dynamic> json) => GrievanceTest(
        grievanceId: json["grievance_id"],
        grievanceMessage: json["grievance_message"],
        statusId: json["status_id"],
        lattitude: json["lattitude"],
        longitude: json["longitude"],
        updatedAt: json["updated_at"],
        officialsId: json["officials_id"],
        officialsName: json["officials_name"],
        officialsDescription: json["officials_description"],
        officialsEmail: json["officials_email"],
        officialsPhone: json["officials_phone"],
        officialsDesignation: json["officials_designation"],
        officialsAddress: json["officials_address"],
        officialsWebsite: json["officials_website"],
        businessHours: json["business_hours"],
        photo: json["photo"],
        typeName: json["type_name"],
        businesstypeName: json["businesstype_name"],
        media: json["media"] == null ? [] : json['media'].toString().split(","),
        docId: json["doc_id"],
      );
}
