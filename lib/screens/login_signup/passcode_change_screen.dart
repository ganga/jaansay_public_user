import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/auth_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class PasscodeChangeScreen extends StatefulWidget {
  final String phone;

  PasscodeChangeScreen(this.phone);

  @override
  _PasscodeChangeScreenState createState() => _PasscodeChangeScreenState();
}

class _PasscodeChangeScreenState extends State<PasscodeChangeScreen> {
  GetStorage box = GetStorage();

  bool isLoad = false;

  submitPasscode(String passcode) async {
    isLoad = true;
    setState(() {});
    AuthService authService = AuthService();
    bool response =
        await authService.updateUserPasscode(widget.phone, passcode);
    if (response) {
      Get.offAll(HomeScreen());
    } else {
      isLoad = false;
      setState(() {});
      Get.rawSnackbar(message: "${tr("Oops! Something went wrong")}");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    "${tr("Enter Your New Passcode")}",
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
                ],
              ),
            ),
    );
  }
}
