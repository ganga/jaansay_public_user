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
      child: RaisedButton(
        onPressed: () {
          Get.off(HomeScreen());
        },
        child: Text("Finish"),
      ),
    );
  }
}
