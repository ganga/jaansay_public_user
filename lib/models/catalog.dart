class Category {
  Category({
    this.ccId,
    this.ccName,
    this.ccPhoto,
  });

  int ccId;
  String ccName;
  String ccPhoto;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        ccId: json["cc_id"],
        ccName: json["cc_name"],
        ccPhoto: json["cc_photo"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "cc_id": ccId,
        "cc_name": ccName,
        "cc_photo": ccPhoto,
      };
}

class Product {
  Product(
      {this.cpId,
      this.ccId,
      this.cpCost,
      this.cpDiscountCost,
      this.cpDescription,
      this.cpName,
      this.cpPriority,
      this.cpStock,
      this.cpHide,
      this.ccName,
      this.ccPhoto,
      this.cpUrl,
      this.cpmId,
      this.cpPhoto,
      this.officialId,
      this.quantity,
      this.cartId});

  String cpId;
  int ccId;
  int cpCost;
  int cpDiscountCost;
  String cpDescription;
  String cpName;
  int cpPriority;
  int cpStock;
  int cpHide;
  String ccName;
  String ccPhoto;
  String cpUrl;
  List<String> cpmId;
  List<String> cpPhoto;
  int officialId;
  int quantity;
  int cartId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      officialId: json["official_id"],
      cpId: json["cp_id"],
      ccId: json["cc_id"],
      cpCost: json["cp_cost"],
      cpDiscountCost: json["cp_discountCost"],
      cpDescription: json["cp_description"],
      cpName: json["cp_name"],
      cpPriority: json["cp_priority"],
      cpStock: json["cp_stock"],
      cpHide: json["cp_hide"],
      ccName: json["cc_name"],
      ccPhoto: json["cc_photo"],
      cpUrl: json["cp_url"],
      cpmId: json["cpm_id"] == null ? [] : json["cpm_id"].toString().split(','),
      cpPhoto: json["cp_photo"] == null
          ? []
          : json["cp_photo"].toString().split(','),
      quantity: json['quantity'],
      cartId: json['cart_id']);
}

class Priority {
  int priorityNumber;
  String priorityName;

  Priority(this.priorityNumber, this.priorityName);
}

class Stock {
  int stockNumber;
  String stockName;

  Stock(this.stockNumber, this.stockName);
}

class UserAddress {
  UserAddress({
    this.addressId,
    this.address,
    this.userId,
    this.name,
    this.city,
    this.state,
    this.pincode,
  });

  int addressId;
  String address;
  int userId;
  String name;
  String city;
  String state;
  String pincode;

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        addressId: json["address_id"],
        address: json["address"],
        userId: json["user_id"],
        name: json["name"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
      );

  Map<String, dynamic> toJson() => {
        "address_id": addressId,
        "address": address,
        "user_id": userId,
        "name": name,
        "city": city,
        "state": state,
        "pincode": pincode,
      };
}
