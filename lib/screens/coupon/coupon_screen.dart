import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_coupon_list_screen.dart';
import 'public_coupon_list_screen.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.primaryColor,
          foregroundColor: Colors.white,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(tabs: [
                Tab(
                  text: "Your Rewards",
                ),
                Tab(
                  text: "Avail Coupons",
                ),
              ]),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserCouponListScreen(),
            PublicCouponListScreen(),
          ],
        ),
      ),
    );
  }
}
