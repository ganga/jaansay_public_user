// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/widgets/poll/poll_secction.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom:  TabBar(
              tabs: [
                Tab(icon: Icon(Icons.poll)),
                Tab(icon: Icon(Icons.feed)),
              ],
            ),
              backgroundColor: Get.theme.primaryColor
          ),
          body:  TabBarView(
            children: [
              PollSection(),
              Icon(Icons.feed),
            ],
          ),
        ),
      ),
    );
  }
}

