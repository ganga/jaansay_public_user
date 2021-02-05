import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/community/profile_screen.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BusinessListItem extends StatelessWidget {
  final Official official;

  BusinessListItem(this.official);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("${official.isPrivate} , ${official.isFollow}");
        if (official.isPrivate == 1 && official.isFollow == null) {
          Get.dialog(AlertDialog(
            title: Text("Private Association"),
            content: Text(
                "Sorry, this is an private association. Only users part of this assocation can view the details. Please contact the admin to join this group."),
            actions: [
              FlatButton(
                onPressed: () {
                  Get.close(1);
                },
                child: Text(
                  "Okay",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          ));
        } else {
          // pushNewScreenWithRouteSettings(context,
          //     screen: ProfileScreen(),
          //     settings: RouteSettings(arguments: [true, official]),
          //     pageTransitionAnimation: PageTransitionAnimation.cupertino);
        }
      },
      child: Container(
        child: Column(
          children: [
            Expanded(child: CustomNetWorkImage(official.photo)),
            SizedBox(
              height: 4,
            ),
            AutoSizeText(
              official.officialsName,
              minFontSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
