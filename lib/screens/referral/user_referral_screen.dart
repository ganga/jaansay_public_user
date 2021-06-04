// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:share/share.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/referral.dart';
import 'package:jaansay_public_user/service/referral_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_divider.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class UserReferralScreen extends StatefulWidget {
  final Official official;

  UserReferralScreen(this.official);

  @override
  _UserReferralScreenState createState() => _UserReferralScreenState();
}

class _UserReferralScreenState extends State<UserReferralScreen> {
  ReferralService referralService = ReferralService();
  ReferralCode referralCode;
  bool isLoad = true;

  generateReferralCode() async {
    await referralService.addReferralCode(widget.official.isReferral);
    getReferralCode();
  }

  getReferralCode() async {
    referralCode =
        await referralService.getReferralCode(widget.official.officialsId);
    if (referralCode == null) {
      generateReferralCode();
    } else {
      isLoad = false;
      setState(() {});
    }
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
        title: Text(
          "Referral Code",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: isLoad
          ? CustomLoading()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          height: Get.width * 0.2,
                          width: Get.width * 0.2,
                          margin: EdgeInsets.only(
                              top: Get.height * 0.07, bottom: 8),
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                              child: CustomNetWorkImage(widget.official.photo)),
                        ),
                        Text(
                          widget.official.officialsName,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.official.businesstypeName,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SelectableText(
                          referralCode.rcUrl,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          referralCode.description,
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomDivider(),
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your benefits",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(referralCode.referrerDescription),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Friend's benefits",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(referralCode.referredDescription)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      onTap: () {
                        Share.share(
                          'Hey!\nHere is my referral code link: ${referralCode.rcUrl}\nUse this code next time you shop at ${referralCode.officialsName}.\n${referralCode.referredDescription}',
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "SHARE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
