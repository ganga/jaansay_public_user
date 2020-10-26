import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/follow_screen.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:jaansay_public_user/widgets/loading.dart';

class Finish extends StatefulWidget {
  Finish({Key key}) : super(key: key);

  @override
  _FinishState createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  final LoginController _loginController = Get.find();
  bool isLoad = false;

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
          title: "Error",
          message: "Oops!! Something went wrong, Please try again.",
          backgroundColor: Get.theme.primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoad
          ? Loading()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/signup.png",
                    height: Get.height * 0.3,
                    width: Get.height * 0.3,
                  ),
                ),
                Text(
                  "All set!!!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  onPressed: () {
                    sendData();
                  },
                  color: Get.theme.primaryColor,
                  child: Text(
                    "Finish",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
    );
  }
}
