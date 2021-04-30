class Coupon {
  Coupon({
    this.cmId,
    this.cmCode,
    this.cmUrl,
    this.title,
    this.description,
    this.cmCreatedAt,
    this.expireOn,
    this.isPublic,
    this.totalCoupon,
    this.couponCount,
    this.cuId,
    this.cuCreatedAt,
    this.caCreatedAt,
    this.officialId,
    this.officialsName,
    this.officialDisplayPhone,
    this.photo,
    this.promoCode,
    this.partnerName,
    this.partnerPhoto,
    this.partnerUrl,
    this.partnerDescription,
  });

  int cmId;
  String cmCode;
  String cmUrl;
  String title;
  String description;
  DateTime cmCreatedAt;
  DateTime expireOn;
  int isPublic;
  int totalCoupon;
  int couponCount;
  int cuId;
  DateTime cuCreatedAt;
  DateTime caCreatedAt;
  int officialId;
  String officialsName;
  String officialDisplayPhone;
  String photo;
  String promoCode;
  String partnerName;
  String partnerPhoto;
  String partnerUrl;
  String partnerDescription;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        cmId: json["cm_id"],
        cmCode: json["cm_code"],
        cmUrl: json["cm_url"],
        title: json["title"],
        description: json["description"],
        cmCreatedAt: json["cm_created_at"] == null
            ? null
            : DateTime.parse(json["cm_created_at"]),
        expireOn: json["expire_on"] == null
            ? null
            : DateTime.parse(json["expire_on"]),
        isPublic: json["is_public"],
        totalCoupon: json["total_coupon"] == null ? null : json["total_coupon"],
        couponCount: json["coupon_count"] == null ? null : json["coupon_count"],
        cuId: json["cu_id"],
        cuCreatedAt: json["cu_created_at"] == null
            ? null
            : DateTime.parse(json["cu_created_at"]),
        caCreatedAt: json["ca_created_at"] == null
            ? null
            : DateTime.parse(json["ca_created_at"]),
        officialId: json["official_id"],
        officialsName: json["officials_name"],
        officialDisplayPhone: json["official_display_phone"],
        photo: json["photo"],
        promoCode: json["promo_code"] == null ? null : json["promo_code"],
        partnerName: json["partner_name"] == null ? null : json["partner_name"],
        partnerPhoto:
            json["partner_photo"] == null ? null : json["partner_photo"],
        partnerUrl: json["partner_url"] == null ? null : json["partner_url"],
        partnerDescription: json["partner_description"] == null
            ? null
            : json["partner_description"],
      );
}

class CouponPartner {
  CouponPartner({
    this.name,
    this.url,
    this.photo,
    this.description,
    this.id,
  });

  String name;
  String url;
  String photo;
  String description;
  int id;

  factory CouponPartner.fromJson(Map<String, dynamic> json) => CouponPartner(
        name: json["name"],
        url: json["url"],
        photo: json["photo"],
        description: json["description"],
        id: json["id"],
      );
}
