import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/referral.dart';
import 'package:jaansay_public_user/screens/referral/accepted_referral_screen.dart';
import 'package:jaansay_public_user/service/referral_service.dart';
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
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 4),
            color: Colors.grey,
            child: Text(
              "Offer Availed",
              style: TextStyle(color: Colors.white),
            ),
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
                      child: CustomNetWorkImage(acceptedReferral.photo),
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
                          text:
                              'Referral you sent to your friend was accepted by '),
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
                  Text("More Details"),
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
        ),
      ),
      body: ListView.builder(
        itemCount: acceptedReferrals.length,
        itemBuilder: (context, index) {
          return referralItem(acceptedReferrals[index]);
        },
      ),
    );
  }
}
