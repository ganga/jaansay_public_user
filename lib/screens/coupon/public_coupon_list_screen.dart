// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/screens/coupon/public_coupon_detail_screen.dart';
import 'package:jaansay_public_user/screens/coupon/user_coupon_list_screen.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class PublicCouponListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context);

    if (!couponProvider.initPublicCoupons) {
      couponProvider.initPublicCoupons = true;
      couponProvider.getAllPublicCoupons();
    }

    return Scaffold(
      body: couponProvider.isPublicCouponLoad
          ? CustomLoading()
          : couponProvider.publicCoupons.length == 0
              ? CustomErrorWidget(
                  title: "No coupons found",
                  description:
                      "Complete surveys, answer feedback and questions to get coupons.",
                  iconData: Icons.card_giftcard,
                )
              : GridView.builder(
                  itemCount: couponProvider.publicCoupons.length,
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
                      child:
                          CouponCard(couponProvider.publicCoupons[index], () {
                        couponProvider.clearData(allData: false);
                        couponProvider.selectedPublicCouponIndex = index;
                        Get.to(() => PublicCouponDetailScreen(),
                            transition: Transition.cupertino);
                      }),
                    ),
                  ),
                ),
    );
  }
}
