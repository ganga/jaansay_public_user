// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileDescriptionScreen extends StatelessWidget {
  final Official official;

  ProfileDescriptionScreen(this.official);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Details",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SelectableText(
            official.detailDescription,
            style: TextStyle(fontSize: 18, letterSpacing: 0.3),
          ),
        ),
      ),
    );
  }
}
