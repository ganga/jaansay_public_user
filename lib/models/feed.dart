class Feed {
  Feed({
    this.feedId,
    this.feedTitle,
    this.feedDescription,
    this.likes,
    this.userId,
    this.typeId,
    this.docId,
    this.updatedAt,
    this.officialsName,
    this.photo,
    this.typeName,
    this.isLiked,
    this.media,
  });

  String feedId;
  String feedTitle;
  String feedDescription;
  int likes;
  int userId;
  int typeId;
  int docId;
  DateTime updatedAt;
  String officialsName;
  String photo;
  String typeName;
  int isLiked;
  List media;

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        feedId: json["feed_id"],
        feedTitle: json["feed_title"],
        feedDescription: json["feed_description"],
        likes: json["likes"],
        userId: json["user_id"],
        typeId: json["type_id"],
        docId: json["doc_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        officialsName: json["officials_name"],
        photo: json["photo"],
        typeName: json["type_name"],
        isLiked: json["is_liked"],
        media: json["media"] == null ? [] : json["media"].toString().split(","),
      );

  Map<String, dynamic> toJson() => {
        "feed_id": feedId,
        "feed_title": feedTitle,
        "feed_description": feedDescription,
        "likes": likes,
        "user_id": userId,
        "type_id": typeId,
        "doc_id": docId,
        "updated_at": updatedAt.toIso8601String(),
        "officials_name": officialsName,
        "photo": photo,
        "type_name": typeName,
        "is_liked": isLiked,
        "media": media == null ? [] : media,
      };
}
