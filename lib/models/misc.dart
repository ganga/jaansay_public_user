class UserType {
  UserType({
    this.typeId,
    this.typeName,
    this.subTypeNames,
  });

  int typeId;
  String typeName;
  List<String> subTypeNames;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
        typeId: json["type_id"],
        typeName: json["type_name"],
        subTypeNames: json["sub_type_names"] == null
            ? []
            : json["sub_type_names"].toString().split(","),
      );
}

class CarouselData {
  CarouselData({
    this.id,
    this.url,
    this.onTap,
    this.code,
  });

  int id;
  String url;
  String onTap;
  int code;

  factory CarouselData.fromJson(Map<String, dynamic> json) => CarouselData(
        id: json["id"],
        url: json["url"],
        onTap: json["onTap"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "onTap": onTap,
        "code": code,
      };
}
