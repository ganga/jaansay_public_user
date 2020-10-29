import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/side_navigation/about_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/feedback_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/vocal_local_screen.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:jaansay_public_user/widgets/misc/edit_profile_dialogue.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int curIndex = 0;
  GetStorage box = GetStorage();

  profileTile(double height, width) {
    return InkWell(
      onTap: () {
        Get.dialog(AlertDialog(
          content: EditProfileDailogue(),
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.05, horizontal: width * 0.08),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(child: CustomNetWorkImage(box.read("photo"))),
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
      ),
      leading: Icon(
        iconData,
        color: curIndex == index ? Theme.of(context).primaryColor : Colors.grey,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Column(
      children: [
        profileTile(_mediaQuery.height, _mediaQuery.width),
        CustomDivider(),
        drawerItem("Home", MdiIcons.home, () {}, 0),
        drawerItem("Feedback", Icons.feedback, () {
          Get.to(FeedbackScreen());
        }, 1),
        drawerItem("Vocal for Local", Icons.record_voice_over, () {
          Get.to(VocalLocalScreen());
        }, 2),
        drawerItem("Share", MdiIcons.share, () {
          Share.share('Download JaanSay app https://play.google.com/store/apps/details?id=com.dev.jaansay_public_user',
              subject: 'This is subject');
        }, 3),
        drawerItem("About", MdiIcons.information, () {
          Get.to(AboutScreen());
        }, 4),
      ],
    );
  }
}
