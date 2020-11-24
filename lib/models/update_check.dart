class UpdateCheck {
  UpdateCheck({
    this.ucId,
    this.version,
    this.versionCode,
    this.updateTitle,
    this.updateDescription,
    this.updateLink,
    this.isAdmin,
  });

  int ucId;
  String version;
  int versionCode;
  String updateTitle;
  String updateDescription;
  String updateLink;
  int isAdmin;

  factory UpdateCheck.fromJson(Map<String, dynamic> json) => UpdateCheck(
        ucId: json["uc_id"],
        version: json["version"],
        versionCode: json["version_code"],
        updateTitle: json["update_title"],
        updateDescription: json["update_description"],
        updateLink: json["update_link"],
        isAdmin: json["is_admin"],
      );

  Map<String, dynamic> toJson() => {
        "uc_id": ucId,
        "version": version,
        "version_code": versionCode,
        "update_title": updateTitle,
        "update_description": updateDescription,
        "update_link": updateLink,
        "is_admin": isAdmin,
      };
}
