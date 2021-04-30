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
