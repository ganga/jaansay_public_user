import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/catalog/product_detail_screen.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/screens/feed/dynamic_feed_detail_screen.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/misc/select_language_screen.dart';
import 'package:jaansay_public_user/screens/referral/friend_referral_screen.dart';

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
      var isOfficial = deepLink.pathSegments.contains('official');
      var isProduct = deepLink.pathSegments.contains('product');
      var isReferral = deepLink.pathSegments.contains('referral');

      if (box.hasData("token")) {
        if (int.parse(box.read("user_id").toString()) > 1000) {
          if (isFeed) {
            var feedId = deepLink.queryParameters['id'];

            if (feedId != null) {
              Get.offAll(DynamicFeedDetailScreen(), arguments: feedId);
            }
          }
          if (isOfficial) {
            var officialId = deepLink.queryParameters['id'];

            if (officialId != null) {
              Get.to(
                  () => ProfileFullScreen(
                        officialId: officialId.toString(),
                        isClose: true,
                      ),
                  transition: Transition.rightToLeft);
            }
          }
          if (isProduct) {
            var productId = deepLink.queryParameters['id'];

            if (productId != null) {
              Get.to(
                  () => ProductDetailScreen(
                        productId: productId.toString(),
                      ),
                  transition: Transition.rightToLeft);
            }
          }
          if (isReferral) {
            var referralId = deepLink.queryParameters['id'];

            if (referralId != null) {
              Get.to(() => FriendReferralScreen(referralId),
                  transition: Transition.rightToLeft);
            }
          }
        } else {
          box.erase();
          Get.offAll(SelectLanguageScreen(), arguments: true);
        }
      } else {
        Get.offAll(SelectLanguageScreen(), arguments: true);
      }
    } else {
      if (box.hasData("token")) {
        Get.offAllNamed(
          HomeScreen.routeName,
        );
      } else {
        Get.offAll(SelectLanguageScreen(), arguments: true);
      }
    }
  }
}
