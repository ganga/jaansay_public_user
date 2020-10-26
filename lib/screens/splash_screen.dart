import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/login_screen.dart';
import 'package:jaansay_public_user/service/dynamic_link_service.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLogin() async {
    DynamicLinkService dynamicLinkService = DynamicLinkService();
    await dynamicLinkService.handleDynamicLinks();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "mainlogo",
              child: Image.asset(
                "assets/images/logo.png",
                height: _mediaQuery.width * 0.2,
                width: _mediaQuery.width * 0.2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: 'Jaan',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Say',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
