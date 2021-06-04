// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/models/referral.dart';
import 'package:jaansay_public_user/screens/referral/accepted_referral_screen.dart';
import 'package:jaansay_public_user/service/referral_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class ReferralListScreen extends StatefulWidget {
  @override
  _ReferralListScreenState createState() => _ReferralListScreenState();
}

class _ReferralListScreenState extends State<ReferralListScreen> {
  ReferralService referralService = ReferralService();
  List<AcceptedReferral> acceptedReferrals = [];
  bool isLoad = true;

  getAcceptedReferrals() async {
    await referralService.getAcceptedReferrals(acceptedReferrals);
    isLoad = false;
    setState(() {});
  }

  referralItem(AcceptedReferral acceptedReferral) {
    return Card(
      child: Column(
        children: [
          if (acceptedReferral.isClosed == 1)
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 4),
              color: Colors.grey,
              child: Text(
                "Offer Availed",
                style: TextStyle(color: Colors.white),
              ).tr(),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.hardEdge,
                      child: CustomNetWorkImage(acceptedReferral.userPhoto),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          acceptedReferral.userName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        Text(
                          "Accepted On: ${DateFormat("dd MMMM yyyy").format(acceptedReferral.acceptedAt)}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: tr(
                              'Referral you sent to your friend was accepted by ')),
                      TextSpan(
                        text: '${acceptedReferral.officialsName}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            width: double.infinity,
            color: Colors.black.withOpacity(0.4),
          ),
          InkWell(
            onTap: () {
              Get.to(() => AcceptedReferralScreen(acceptedReferral),
                  transition: Transition.rightToLeft);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("More Details").tr(),
                  const SizedBox(
                    width: 6,
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 25,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAcceptedReferrals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Your Referrals",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ).tr(),
      ),
      body: isLoad
          ? CustomLoading(title: "Loading Referrals")
          : acceptedReferrals.length == 0
              ? CustomErrorWidget(
                  iconData: FontAwesomeIcons.userFriends,
                  title: tr("No Referrals"),
                  description: tr(
                      "Refer your friends to purchase from businesses and get offers. Click on refer & earn in business profile to refer."),
                )
              : ListView.builder(
                  itemCount: acceptedReferrals.length,
                  itemBuilder: (context, index) {
                    return referralItem(acceptedReferrals[index]);
                  },
                ),
    );
  }
}
