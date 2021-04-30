import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/coupon_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_divider.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponDynamicScreen extends StatefulWidget {
  final String couponId;

  CouponDynamicScreen(this.couponId);

  @override
  _CouponDynamicScreenState createState() => _CouponDynamicScreenState();
}

class _CouponDynamicScreenState extends State<CouponDynamicScreen> {
  CouponService couponService = CouponService();
  bool isLoad = true;
  Coupon coupon;

  getCouponDetails() async {
    coupon = await couponService.getCouponDetailsByCouponId(widget.couponId);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCouponDetails();
  }

  @override
  Widget build(BuildContext context) {
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
        leading: InkWell(
            onTap: () {
              Get.offAll(HomeScreen());
            },
            child: Icon(Icons.arrow_back_outlined)),
        actions: [
          if (!isLoad)
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
      body: WillPopScope(
        onWillPop: () async {
          await Get.offAll(HomeScreen());
          return false;
        },
        child: isLoad
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
                            coupon.expireOn.isBefore(DateTime.now()) ||
                                    coupon.caCreatedAt != null
                                ? Container(
                                    height: Get.width * 0.2,
                                    width: Get.width * 0.2,
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: ClipOval(
                                      child: CustomNetWorkImage(coupon.photo),
                                    ),
                                  )
                                : QrImage(
                                    data: json.encode({
                                      "type": "coupon",
                                      "user_id": GetStorage()
                                          .read("user_id")
                                          .toString(),
                                      "code": coupon.cmCode
                                    }),
                                    version: QrVersions.auto,
                                    size: 200.0,
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
                              child: coupon.caCreatedAt != null
                                  ? Text("Coupon already used")
                                  : Text(
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
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
      ),
    );
  }
}
