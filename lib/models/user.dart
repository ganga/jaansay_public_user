class User {
  var user_id;
  var user_name;
  var user_gender;
  var user_dob;
  var user_pincode;
  var user_phone;
  var photo;
  var panchayat_name;
  var type_name;

  User(
      {this.user_id,
      this.user_name,
      this.user_gender,
      this.user_dob,
      this.user_pincode,
      this.user_phone,
      this.photo,
      this.panchayat_name,
      this.type_name});

  User.fromMap(Map<String, dynamic> map) {
    this.user_id = map['user_id'];
    this.user_name = map['user_name'];
    this.user_gender = map['user_gender'];
    this.user_dob = map['user_dob'];
    this.user_pincode = map['user_pincode'];
    this.photo = map['photo'];
    this.panchayat_name = map['panchayat_name'];
    this.type_name = map['type_name'];
  }
}
