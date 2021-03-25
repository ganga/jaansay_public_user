import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';

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
        ),
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
