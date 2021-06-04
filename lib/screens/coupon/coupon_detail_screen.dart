// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:clipboard/clipboard.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/widgets/general/custom_divider.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class CouponDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context);

    Coupon coupon = couponProvider.coupons[couponProvider.selectedCouponIndex];

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
              final url =
                  "tel:${couponProvider.coupons[couponProvider.selectedCouponIndex].officialDisplayPhone}";
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
      body: Column(
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
                    coupon.expireOn.isBefore(DateTime.now())
                        ? Container(
                            height: Get.width * 0.2,
                            width: Get.width * 0.2,
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                              child: CustomNetWorkImage(couponProvider
                                  .coupons[couponProvider.selectedCouponIndex]
                                  .photo),
                            ),
                          )
                        : coupon.promoCode != null
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: ClipOval(
                                        child: CustomNetWorkImage(
                                            coupon.partnerPhoto),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${coupon.partnerName}",
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
                                            coupon.partnerDescription,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Get.theme.primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            width: Get.width * 0.6,
                                            margin: EdgeInsets.only(bottom: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    coupon.promoCode,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Get
                                                            .theme.primaryColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.5),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.copy,
                                                    color:
                                                        Get.theme.primaryColor,
                                                  ),
                                                  onPressed: () {
                                                    FlutterClipboard.copy(
                                                            coupon.promoCode)
                                                        .then(
                                                      (value) => Get.rawSnackbar(
                                                          message:
                                                              "Code has been copied to clipboard"),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : QrImage(
                                data: json.encode({
                                  "type": "coupon",
                                  "user_id":
                                      GetStorage().read("user_id").toString(),
                                  "code": couponProvider
                                      .coupons[
                                          couponProvider.selectedCouponIndex]
                                      .cmCode
                                }),
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                    Text(
                      coupon.officialsName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      coupon.title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 22),
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
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Offer Details:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            coupon.description,
                            style: TextStyle(
                                letterSpacing: 0.5, height: 1.25, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
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
