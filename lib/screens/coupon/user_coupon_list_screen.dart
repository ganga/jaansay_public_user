import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/screens/coupon/coupon_detail_screen.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:provider/provider.dart';

class UserCouponListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context);

    if (!couponProvider.initCoupons) {
      couponProvider.initCoupons = true;
      couponProvider.getAllCoupons();
    }

    return Scaffold(
      body: couponProvider.isCouponLoad
          ? CustomLoading()
          : couponProvider.coupons.length == 0
              ? CustomErrorWidget(
                  title: "No coupons found",
                  description:
                      "Complete surveys, answer feedback and questions to get coupons.",
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
                      child: CouponCard(couponProvider.coupons[index], () {
                        couponProvider.selectedCouponIndex = index;
                        Get.to(() => CouponDetailScreen(),
                            transition: Transition.cupertino);
                      }),
                    ),
                  ),
                ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final Function onTap;

  CouponCard(this.coupon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              maxLines: 1,
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
}
