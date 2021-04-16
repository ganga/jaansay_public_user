import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/referral.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/referral_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_divider.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FriendReferralScreen extends StatefulWidget {
  final String referralCode;

  FriendReferralScreen(this.referralCode);

  @override
  _FriendReferralScreenState createState() => _FriendReferralScreenState();
}

class _FriendReferralScreenState extends State<FriendReferralScreen> {
  ReferralService referralService = ReferralService();
  ReferralCode referralCode;
  bool isLoad = true;
  bool isError = false;

  getReferralCode() async {
    referralCode =
        await referralService.getReferralCodeDetails(widget.referralCode);
    if (referralCode == null) {
      isError = true;
      isLoad = false;
    } else {
      isLoad = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReferralCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              Get.offAll(HomeScreen());
            },
            child: Icon(Icons.arrow_back_outlined)),
        title: Text(
          "Referral Code",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await Get.offAll(HomeScreen());
          return false;
        },
        child: isLoad
            ? CustomLoading()
            : isError
                ? CustomErrorWidget(
                    title: "Invalid Code",
                    iconData: Icons.error_outline,
                  )
                : SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Container(
                            height: Get.width * 0.2,
                            width: Get.width * 0.2,
                            margin: EdgeInsets.only(
                                top: Get.height * 0.07, bottom: 8),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                                child: CustomNetWorkImage(referralCode.photo)),
                          ),
                          Text(
                            referralCode.officialsName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          QrImage(
                            data: json.encode({
                              "type": "referral",
                              "user_id":
                                  GetStorage().read("user_id").toString(),
                              "code": referralCode.rcCode
                            }),
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            referralCode.referredDescription,
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomDivider(),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                              "Show this code to the business and avail the offer."),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
