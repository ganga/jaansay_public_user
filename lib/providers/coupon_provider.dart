import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/service/coupon_service.dart';

class CouponProvider extends ChangeNotifier {
  CouponService couponService = CouponService();

  int selectedCouponIndex;
  List<Coupon> coupons = [];

  bool initCoupons = false;
  bool isCouponLoad = true;

  getAllCoupons() async {
    await couponService.getCoupons(coupons);
    isCouponLoad = false;
    notifyListeners();
  }

  clearData() {
    initCoupons = false;
    isCouponLoad = true;
    coupons.clear();
    selectedCouponIndex = null;
  }
}
