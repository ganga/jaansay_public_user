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
      this.isPrivate});

  int officialsId;
  String officialsName;
  String officialsDescription;
  String officialsEmail;
  String officialsPhone;
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
  dynamic isFollow;
  int isRating;
  int isPrivate;

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
      isFollow: json["is_follow"],
      isRating: json["is_rating"],
      isPrivate: json['is_private']);

  Map<String, dynamic> toJson() => {
        "officials_id": officialsId,
        "officials_name": officialsName,
        "officials_description": officialsDescription,
        "officials_email": officialsEmail,
        "officials_phone": officialsPhone,
        "officials_designation": officialsDesignation,
        "lattitude": lattitude,
        "longitude": longitude,
        "officials_address": officialsAddress,
        "officials_website": officialsWebsite,
        "business_hours": businessHours,
        "photo": photo,
        "average_rating": averageRating,
        "total_rating": totalRating,
        "type_name": typeName,
        "businesstype_name": businesstypeName,
        "is_follow": isFollow,
        "is_rating": isRating,
        "is_private": isPrivate
      };
}
