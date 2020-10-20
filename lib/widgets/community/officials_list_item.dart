import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
        pushNewScreenWithRouteSettings(context,
            screen: ProfileScreen(),
            settings: RouteSettings(),
            pageTransitionAnimation: PageTransitionAnimation.cupertino);
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
