import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/service/coupon_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_dialog.dart';

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
      isPublicCouponDetailLoad = true;

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
    await couponService.getCouponPartners(
        couponPartners, publicCoupons[selectedPublicCouponIndex].cmId);
    isPublicCouponDetailLoad = false;
    notifyListeners();
  }

  addCouponUser(int index) async {
    isPublicCouponLoad = true;
    notifyListeners();
    CouponPartner couponPartner;
    if (index > 0) {
      couponPartner = couponPartners[index];
    }
    await updateUserPoints();

    if (couponPartner == null || couponPartner.id == 1) {
      await couponService.addCouponUsers(
          publicCoupons[selectedPublicCouponIndex].cmId,
          publicCoupons[selectedPublicCouponIndex].officialId);
      Get.close(1);
      Get.rawSnackbar(message: "You have availed the coupon.");
      clearData();
    } else {
      String code = await couponService.getCouponPromoCode(
          couponPartner.id, publicCoupons[selectedPublicCouponIndex].cmId);
      Get.close(1);
      clearData();
      Get.dialog(
        AlertDialog(
          title: Text("Promo Code"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Use this promo code in the application to avail the offer."),
              const SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        code,
                        style: TextStyle(
                            fontSize: 16,
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: Get.theme.primaryColor,
                      ),
                      onPressed: () {
                        FlutterClipboard.copy(code).then(
                          (value) => Get.rawSnackbar(
                              message: "Code has been copied to clipboard"),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
          actions: [
            CustomDialogButton(
              color: Get.theme.primaryColor,
              onTap: () => Get.back(),
              text: "Close",
            )
          ],
        ),
      );
    }
    notifyListeners();
  }

  updateUserPoints() async {
    await couponService.updateUserPoints(0);
  }

  clearData({bool allData = true}) {
    if (allData) {
      initCoupons = false;
      initPublicCoupons = false;

      isCouponLoad = true;
      isPublicCouponLoad = true;

      coupons.clear();
      publicCoupons.clear();

      selectedCouponIndex = null;
    }
    selectedPublicCouponIndex = null;
    isPublicCouponDetailLoad = true;
    initPublicCouponDetails = false;
    couponPartners.clear();
  }
}
