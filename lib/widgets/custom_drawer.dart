import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/screens/catalog/order_screen.dart';
import 'package:jaansay_public_user/screens/coupon/coupon_list_screen.dart';
import 'package:jaansay_public_user/screens/misc/select_language_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/about_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/feedback_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/vocal_local_screen.dart';
import 'package:jaansay_public_user/widgets/misc/edit_profile_dialogue.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'general/custom_divider.dart';
import 'general/custom_network_image.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int curIndex = 0;
  GetStorage box = GetStorage();
  String img;

  profileTile() {
    return InkWell(
      onTap: () {
        Get.dialog(AlertDialog(
          content: EditProfileDailogue(() {
            img = box.read("photo");
            PaintingBinding.instance.imageCache.clear();
            setState(() {});
          }),
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.05, horizontal: Get.width * 0.08),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(child: CustomNetWorkImage(img)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${box.read("user_name")}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "+91 ${box.read("user_phone")}",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  drawerItem(
    String title,
    IconData iconData,
    Function onTap,
    int index,
  ) {
    return ListTile(
      tileColor: curIndex == index
          ? Theme.of(context).primaryColor.withOpacity(0.05)
          : Colors.transparent,
      title: Text(
        "$title",
        style: TextStyle(
            color: curIndex == index
                ? Theme.of(context).primaryColor
                : Colors.grey),
      ).tr(),
      leading: Icon(
        iconData,
        color: curIndex == index ? Theme.of(context).primaryColor : Colors.grey,
      ),
      onTap: onTap,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    img = box.read("photo");
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    return Column(
      children: [
        profileTile(),
        CustomDivider(),
        drawerItem("Home", MdiIcons.home, () {}, 0),
        drawerItem("Your Orders", Icons.shopping_cart_outlined, () {
          Get.close(1);

          Get.to(() => OrderScreen(), transition: Transition.leftToRight);
        }, 1),
        drawerItem("Feedback", Icons.feedback, () {
          Get.close(1);

          Get.to(() => FeedbackScreen(), transition: Transition.leftToRight);
        }, 1),
        drawerItem("Vocal For Local", Icons.record_voice_over, () {
          Get.close(1);

          Get.to(() => VocalLocalScreen(), transition: Transition.leftToRight);
        }, 1),
        drawerItem("Language", Icons.language, () {
          Get.close(1);

          Get.to(() => SelectLanguageScreen(),
              transition: Transition.leftToRight);
        }, 1),
        drawerItem("Share", MdiIcons.share, () {
          Get.close(1);

          Share.share(
            'Download JaanSay app https://play.google.com/store/apps/details?id=com.dev.jaansay_public_user',
          );
        }, 1),
        drawerItem("About", MdiIcons.information, () {
          Get.close(1);

          Get.to(() => AboutScreen(), transition: Transition.leftToRight);
        }, 1),
      ],
    );
  }
}
