// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/widgets/poll/poll_section.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/screens/coupon/coupon_screen.dart';
import 'package:jaansay_public_user/screens/misc/point_screen.dart';
import 'package:jaansay_public_user/screens/referral/referral_list_screen.dart';
import 'package:jaansay_public_user/widgets/dashboard/carousel_section.dart';
import 'package:jaansay_public_user/widgets/dashboard/grievance_section.dart';
import 'package:jaansay_public_user/widgets/dashboard/message_section.dart';
import 'package:jaansay_public_user/widgets/dashboard/store_section.dart';
import 'package:jaansay_public_user/widgets/dashboard/survey_feedback_section.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            PollSection(),
            // CarouselSection(),
            // MessageSection(),
            // _PromotionSection(),
            // GrievanceSection(),
            // SurveyFeedbackSection(),
            // StoreSection()
          ],
        ),
      ),
    );
  }
}


class _PromotionSection extends StatelessWidget {
  promotionItem(String title, IconData iconData, Function onTap) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Get.theme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Get.theme.primaryColor.withAlpha(155),
                          blurRadius: 5,
                          spreadRadius: 1)
                    ]),
                width: 55,
                height: 55,
                clipBehavior: Clip.hardEdge,
                child: Icon(
                  iconData,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "View My",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ).tr(),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ).tr()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Promotions",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.65),
                  letterSpacing: 0.45),
            ).tr(),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                promotionItem("Points", FontAwesomeIcons.moneyBillWave, () {
                  Get.to(() => PointsScreen(),
                      transition: Transition.rightToLeft);
                }),
                Container(
                  height: 75,
                  width: 0.5,
                  color: Colors.grey,
                ),
                promotionItem("Rewards", FontAwesomeIcons.gift, () {
                  couponProvider.clearData();
                  Get.to(() => CouponScreen(),
                      transition: Transition.rightToLeft);
                }),
                Container(
                  height: 75,
                  width: 0.5,
                  color: Colors.grey,
                ),
                promotionItem("Referrals", FontAwesomeIcons.userFriends, () {
                  Get.to(() => ReferralListScreen(),
                      transition: Transition.rightToLeft);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
