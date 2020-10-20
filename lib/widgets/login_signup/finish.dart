import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';

class Finish extends StatelessWidget {
  Finish({Key key}) : super(key: key);
  final LoginController _loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
              Get.off(HomeScreen());
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
