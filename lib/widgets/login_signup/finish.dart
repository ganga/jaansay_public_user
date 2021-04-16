import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/login_signup/follow_screen.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_auth_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Finish extends StatefulWidget {
  Finish({Key key}) : super(key: key);

  @override
  _FinishState createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  bool isLoad = false;
  bool isComplete = false;
  GetStorage box = GetStorage();

  sendData() async {
    isLoad = true;
    setState(() {});
    UserService userService = UserService();
    final response = await userService.createUser();
    if (response) {
      isLoad = false;
      setState(() {});
      Get.offAll(FollowScreen());
    } else {
      Get.rawSnackbar(
        message: tr("Oops! Something went wrong"),
      );
    }
  }

  Widget pincodeField(BuildContext context) {
    return PinCodeTextField(
      backgroundColor: Colors.transparent,
      pinTheme: PinTheme.defaults(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          activeColor: Theme.of(context).primaryColor,
          selectedColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.black12),
      appContext: context,
      length: 4,
      obscureText: false,
      autoFocus: true,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      animationDuration: Duration(milliseconds: 300),
      onChanged: (val) {
        if (val.length == 4) {
          Get.focusScope.unfocus();
          box.write("register_password", val.toString());
          isComplete = true;
          setState(() {});
        } else {
          isComplete = false;
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoad
          ? CustomLoading()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/signup.png",
                      height: Get.height * 0.3,
                      width: Get.height * 0.3,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                    child: pincodeField(context),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomAuthButton(
                    onTap: isComplete
                        ? () {
                            sendData();
                          }
                        : null,
                    title: "${tr("Sign Up")}",
                  )
                ],
              ),
            ),
    );
  }
}
