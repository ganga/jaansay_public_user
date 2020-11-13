import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/screens/login_signup/otp_verfication_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/signup.png",
                height: _mediaQuery.height * 0.3,
                width: _mediaQuery.height * 0.3,
              ),
            ),
            Text(
              "${tr("Verify your phone number")}!",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "${tr("phone")}",
                  hintText: "${tr("Enter your phone number")}",
                ),
              ),
            ),
            FlatButton(
              child: Text(
                "Already have an account? Login now",
                style: TextStyle(
                  fontSize: 15,
                ),
              ).tr(),
              onPressed: () {},
            ),
            Container(
              height: _mediaQuery.height * 0.07,
              width: double.infinity,
              margin: EdgeInsets.all(8),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Get.to(OtpVerificationScreen());
                },
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
