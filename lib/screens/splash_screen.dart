import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/update_check.dart';
import 'package:jaansay_public_user/service/dynamic_link_service.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLogin() async {
    Dio dio = new Dio();
    final response = await dio.get("${Constants.url}updatecheck/0");
    if (response.data["success"]) {
      UpdateCheck updateCheck = UpdateCheck.fromJson(response.data['data']);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      print(updateCheck.version);
      if (updateCheck.version == "0") {
        Get.dialog(
          AlertDialog(
            title: Text(updateCheck.updateTitle),
            content: Text(updateCheck.updateDescription),
            actions: [
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  "Close",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ).tr(),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else if (updateCheck.version == "-1" ||
          version == updateCheck.version) {
        Future.delayed(
            Duration(
              milliseconds: 500,
            ), () async {
          DynamicLinkService dynamicLinkService = DynamicLinkService();
          await dynamicLinkService.handleDynamicLinks();
        });
      } else {
        Get.dialog(
          AlertDialog(
            title: Text(updateCheck.updateTitle),
            content: Text(updateCheck.updateDescription),
            actions: [
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  "Close",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ).tr(),
              ),
              TextButton(
                onPressed: () => launch(updateCheck.updateLink),
                child: Text(
                  "Update",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ).tr(),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    } else {
      Get.rawSnackbar(
          message: tr(
              "Server is under maintenance, please try again after sometime."),
          duration: Duration(seconds: 5));
    }
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
              tag: tr("mainlogo"),
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
                  text: "${tr('Jaan')}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                  children: <TextSpan>[
                    TextSpan(
                      text: "${tr('Say')}",
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
