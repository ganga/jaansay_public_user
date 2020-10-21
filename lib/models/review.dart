class Review {
  Review({
    this.ratingId,
    this.rating,
    this.ratingMessage,
    this.userId,
    this.officialId,
    this.updatedAt,
    this.userName,
    this.photo,
  });

  var ratingId;
  var rating;
  var ratingMessage;
  var userId;
  var officialId;
  var updatedAt;
  var userName;
  var photo;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        ratingId: json["rating_id"],
        rating: json["rating"],
        ratingMessage: json["rating_message"],
        userId: json["user_id"],
        officialId: json["official_id"],
        updatedAt: json["updated_at"],
        userName: json["user_name"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "rating_id": ratingId,
        "rating": rating,
        "rating_message": ratingMessage,
        "user_id": userId,
        "official_id": officialId,
        "updated_at": updatedAt,
        "user_name": userName,
        "photo": photo,
      };
}
