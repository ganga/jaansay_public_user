import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:jaansay_public_user/widgets/login_signup/about.dart';
import 'package:jaansay_public_user/widgets/login_signup/finish.dart';
import 'package:jaansay_public_user/widgets/misc/screen_progress.dart';

class AboutMeScreen extends StatelessWidget {
  AboutMeScreen({Key key}) : super(key: key);
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "User Setup",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ).tr(),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (_loginController.index.value == 0) {
            return true;
          } else {
            _loginController.index(_loginController.index.value - 1);
            return false;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(8),
                alignment: Alignment.center,
                child: ScreenProgress(),
              ),
              Obx(() {
                return Expanded(
                  child: IndexedStack(
                    index: _loginController.index.value,
                    children: [
                      About(),
                      Finish(),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
