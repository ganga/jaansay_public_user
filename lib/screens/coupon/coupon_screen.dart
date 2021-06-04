// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'public_coupon_list_screen.dart';
import 'user_coupon_list_screen.dart';

class CouponScreen extends StatelessWidget {
  final int initialIndex;

  CouponScreen({this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
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
                  text: "I AM BLOOD BUDDY",
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
