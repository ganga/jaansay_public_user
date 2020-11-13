import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:jaansay_public_user/widgets/login_signup/about.dart';
import 'package:jaansay_public_user/widgets/login_signup/address.dart';
import 'package:jaansay_public_user/widgets/login_signup/finish.dart';
import 'package:jaansay_public_user/widgets/misc/screen_progress.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutMeScreen extends StatelessWidget {
  AboutMeScreen({Key key}) : super(key: key);
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "User Setup",
          textAlign: TextAlign.center,
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
                      Address(),
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
