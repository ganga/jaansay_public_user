import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/widgets/general/custom_dialog.dart';
import 'package:jaansay_public_user/widgets/general/custom_divider.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicCouponDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context);

    if (!couponProvider.initPublicCouponDetails) {
      couponProvider.initPublicCouponDetails = true;
      couponProvider.getCouponPartners();
    }

    Coupon coupon =
        couponProvider.publicCoupons[couponProvider.selectedPublicCouponIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Coupon Details",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () async {
              final url = "tel:${coupon.officialDisplayPhone}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw '${"Could not launch"} $url';
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.call,
                size: 28,
                color: Get.theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: couponProvider.isPublicCouponDetailLoad
          ? CustomLoading()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: Get.height * 0.05),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            height: Get.width * 0.2,
                            width: Get.width * 0.2,
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                              child: CustomNetWorkImage(coupon.photo),
                            ),
                          ),
                          Text(
                            coupon.officialsName,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            coupon.title,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          if (coupon.totalCoupon > 0)
                            Text(
                              coupon.totalCoupon == coupon.couponCount
                                  ? "Out of stock"
                                  : "Only ${coupon.totalCoupon - coupon.couponCount} coupons left",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Get.theme.primaryColor,
                                  letterSpacing: 0.45),
                            ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 22),
                            decoration: BoxDecoration(
                              color: coupon.expireOn.isBefore(DateTime.now())
                                  ? Colors.grey.withAlpha(50)
                                  : Get.theme.primaryColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "${coupon.expireOn.isBefore(DateTime.now()) ? 'Expired on' : 'Expires on'}: ${DateFormat("dd MMM").format(coupon.expireOn)}",
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomDivider(
                            isColor: true,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Offer Details:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.65),
                                      letterSpacing: 0.45),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  coupon.description,
                                  style: TextStyle(
                                      letterSpacing: 0.5,
                                      height: 1.25,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          if (couponProvider.userPoints >= 100 &&
                              (coupon.totalCoupon == 0 ||
                                  coupon.totalCoupon > coupon.couponCount))
                            couponProvider.couponPartners.length > 1
                                ? Column(
                                    children: [
                                      Text(
                                        "You can avail the coupons in the below given applications",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color:
                                                Colors.black.withOpacity(0.65),
                                            letterSpacing: 0.45),
                                      ),
                                      ListView.builder(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        itemCount: couponProvider
                                            .couponPartners.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return _PartnerSection(index);
                                        },
                                      )
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      couponProvider.addCouponUser(-1);
                                    },
                                    child: Text("Avail Coupon"),
                                  ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _PartnerSection extends StatelessWidget {
  final int index;

  _PartnerSection(this.index);

  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context);

    CouponPartner couponPartner = couponProvider.couponPartners[index];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: CustomNetWorkImage(couponPartner.photo),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${couponPartner.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  couponPartner.description,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 0.5),
                      color: Theme.of(context).primaryColor),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        couponProvider.addCouponUser(index);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Avail Coupon",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
