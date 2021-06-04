// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Project imports:
import 'package:jaansay_public_user/models/referral.dart';
import 'package:jaansay_public_user/widgets/general/custom_divider.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class AcceptedReferralScreen extends StatelessWidget {
  final AcceptedReferral acceptedReferral;

  AcceptedReferralScreen(this.acceptedReferral);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Referral Details",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Container(
                height: Get.width * 0.2,
                width: Get.width * 0.2,
                margin: EdgeInsets.only(top: Get.height * 0.07, bottom: 8),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                    child: CustomNetWorkImage(acceptedReferral.officialPhoto)),
              ),
              Text(
                acceptedReferral.officialsName,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              QrImage(
                data: json.encode({
                  "type": "referral accepted",
                  "user_id": GetStorage().read("user_id").toString(),
                  "code": acceptedReferral.raId
                }),
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                acceptedReferral.referrerDescription,
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
              acceptedReferral.isClosed == 0
                  ? Text(
                      "Show this code to the business and avail the offer.",
                      textAlign: TextAlign.center,
                    )
                  : Text("Your have availed this offer.")
            ],
          ),
        ),
      ),
    );
  }
}
