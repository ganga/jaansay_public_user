import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/service/coupon_service.dart';

class CouponProvider extends ChangeNotifier {
  CouponService couponService = CouponService();

  List<Coupon> coupons = [];
  List<Coupon> publicCoupons = [];
  List<CouponPartner> couponPartners = [];

  int selectedPublicCouponIndex;
  int selectedCouponIndex;

  bool initCoupons = false,
      initPublicCoupons = false,
      initPublicCouponDetails = false;
  bool isCouponLoad = true,
      isPublicCouponLoad = true,
      isPublicCouponDetailLoad = false;

  int userPoints;

  getAllCoupons() async {
    await couponService.getCoupons(coupons);
    isCouponLoad = false;
    notifyListeners();
  }

  getAllPublicCoupons() async {
    userPoints = await couponService.getUserPoints();
    await couponService.getPublicCoupons(publicCoupons);
    isPublicCouponLoad = false;
    notifyListeners();
  }

  getCouponPartners() async {
    isPublicCouponDetailLoad = true;
    notifyListeners();
    await couponService.getCouponPartners(
        couponPartners, publicCoupons[selectedPublicCouponIndex].cmId);
    if (couponPartners.length == 0) {
      addCouponUser();
    } else {
      isPublicCouponDetailLoad = false;
      notifyListeners();
    }
  }

  addCouponUser() async {
    await couponService
        .addCouponUsers(publicCoupons[selectedPublicCouponIndex].cmId);
    await updateUserPoints();
    Get.close(1);
    Get.rawSnackbar(message: "You have availed the coupon.");
    clearData();
  }

  updateUserPoints() async {
    await couponService.updateUserPoints(0);
  }

  clearData() {
    initCoupons = false;
    initPublicCoupons = false;
    initPublicCouponDetails = false;

    isCouponLoad = true;
    isPublicCouponLoad = true;
    isPublicCouponDetailLoad = false;

    coupons.clear();
    publicCoupons.clear();
    couponPartners.clear();

    selectedCouponIndex = null;
    selectedPublicCouponIndex = null;
  }
}
