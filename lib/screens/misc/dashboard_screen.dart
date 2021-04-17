import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/screens/coupon/coupon_list_screen.dart';
import 'package:jaansay_public_user/widgets/dashboard/message_section.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [MessageSection(), _PromotionSection()],
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
              ),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            "Promotions",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black.withAlpha(180),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              promotionItem("Points", FontAwesomeIcons.moneyBillWave, () {}),
              Container(
                height: 75,
                width: 0.5,
                color: Colors.grey,
              ),
              promotionItem("Rewards", FontAwesomeIcons.gift, () {
                couponProvider.clearData();
                Get.to(() => CouponListScreen(),
                    transition: Transition.rightToLeft);
              }),
              Container(
                height: 75,
                width: 0.5,
                color: Colors.grey,
              ),
              promotionItem("Referrals", FontAwesomeIcons.userFriends, () {}),
            ],
          )
        ],
      ),
    );
  }
}
