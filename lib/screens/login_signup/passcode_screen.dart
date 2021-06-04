// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/otp_verfication_screen.dart';
import 'package:jaansay_public_user/service/auth_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class PasscodeScreen extends StatefulWidget {
  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  GetStorage box = GetStorage();

  bool isLoad = false;

  String phone = "";

  submitPasscode(String passcode) async {
    isLoad = true;
    setState(() {});
    AuthService authService = AuthService();
    bool response = await authService.loginUser(phone, passcode);
    if (response) {
      Get.offAll(HomeScreen());
    } else {
      isLoad = false;
      setState(() {});
      Get.rawSnackbar(message: "${tr("Incorrect Passcode")}");
    }
  }

  @override
  Widget build(BuildContext context) {
    phone = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "${tr("login")}",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoad
          ? CustomLoading()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/l2.png",
                      height: Get.height * 0.3,
                      width: Get.height * 0.3,
                    ),
                  ),
                  Text(
                    "${tr("Enter Your Passcode")}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.1, vertical: 8),
                    child: CustomPinField(submitPasscode, 4),
                  ),
                  TextButton(
                    child: Text(
                      "${tr("forgot passcode")}",
                      style: TextStyle(
                          fontSize: 15, color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Get.to(() => OtpVerificationScreen(null, phone),
                          transition: Transition.rightToLeft);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
