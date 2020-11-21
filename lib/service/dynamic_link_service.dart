import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/feed/dynamic_feed_detail_screen.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/login_screen.dart';
import 'package:jaansay_public_user/screens/misc/select_language_screen.dart';
import 'package:jaansay_public_user/screens/splash_screen.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    GetStorage box = GetStorage();

    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      var isFeed = deepLink.pathSegments.contains('feed');

      if (box.hasData("token")) {
        if (isFeed) {
          var feedId = deepLink.queryParameters['id'];

          if (feedId != null) {
            Get.offAll(DynamicFeedDetailScreen(), arguments: feedId);
          }
        }
      } else {
        Get.offAll(SelectLanguageScreen(), arguments: true);
      }
    } else {
      if (box.hasData("token")) {
        Get.offAll(
          HomeScreen(),
        );
      } else {
        Get.offAll(SelectLanguageScreen(), arguments: true);
      }
    }
  }
}
