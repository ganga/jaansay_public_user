class Coupon {
  Coupon({
    this.cmId,
    this.cmCode,
    this.cmUrl,
    this.title,
    this.description,
    this.cmCreatedAt,
    this.expireOn,
    this.cuId,
    this.cuCreatedAt,
    this.caCreatedAt,
    this.officialId,
    this.officialsName,
    this.officialsPhone,
    this.photo,
  });

  int cmId;
  String cmCode;
  String cmUrl;
  String title;
  String description;
  DateTime cmCreatedAt;
  DateTime expireOn;
  int cuId;
  DateTime cuCreatedAt;
  DateTime caCreatedAt;
  int officialId;
  String officialsName;
  String officialsPhone;
  String photo;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        cmId: json["cm_id"],
        cmCode: json["cm_code"],
        cmUrl: json["cm_url"],
        title: json["title"],
        description: json["description"],
        cmCreatedAt: DateTime.parse(json["cm_created_at"]),
        expireOn: DateTime.parse(json["expire_on"]),
        cuId: json["cu_id"],
        cuCreatedAt: json["cu_created_at"] == null
            ? null
            : DateTime.parse(json["cu_created_at"]),
        caCreatedAt: json["ca_created_at"] == null
            ? null
            : DateTime.parse(json["ca_created_at"]),
        officialId: json["official_id"],
        officialsName: json["officials_name"],
        officialsPhone: json["official_display_phone"],
        photo: json["photo"],
      );
}
