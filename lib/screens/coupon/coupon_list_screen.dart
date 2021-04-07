import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/screens/coupon/coupon_detail_screen.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';

import 'package:provider/provider.dart';

class CouponListScreen extends StatelessWidget {
  couponCard(CouponProvider couponProvider, int index) {
    Coupon coupon = couponProvider.coupons[index];

    return InkWell(
      onTap: () {
        couponProvider.selectedCouponIndex = index;
        Get.to(CouponDetailScreen(), transition: Transition.cupertino);
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: CustomNetWorkImage(coupon.photo),
              ),
            ),
            Text(
              coupon.officialsName,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            Text(
              coupon.title,
              style: TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                color: coupon.expireOn.isBefore(DateTime.now())
                    ? Colors.grey.withAlpha(50)
                    : Get.theme.primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(
                "${coupon.expireOn.isBefore(DateTime.now()) ? 'Expired on' : 'Expires on'}: ${DateFormat("dd MMM").format(coupon.expireOn)}",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                maxLines: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context);

    if (!couponProvider.initCoupons) {
      couponProvider.initCoupons = true;
      couponProvider.getAllCoupons();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Your Coupons",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      body: couponProvider.isCouponLoad
          ? Loading()
          : couponProvider.coupons.length == 0
              ? CustomErrorWidget(
                  title: "No coupons found",
                  iconData: Icons.card_giftcard,
                )
              : GridView.builder(
                  itemCount: couponProvider.coupons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: Get.height * 0.02),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  itemBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: couponCard(couponProvider, index),
                    ),
                  ),
                ),
    );
  }
}
