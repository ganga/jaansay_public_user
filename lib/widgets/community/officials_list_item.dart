import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/community/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BusinessListItem extends StatelessWidget {
  final String type;

  BusinessListItem(this.type);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreenWithRouteSettings(context,
            screen: ProfileScreen(),
            settings: RouteSettings(arguments: type),
            pageTransitionAnimation: PageTransitionAnimation.cupertino);
      },
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                "https://www.avcj.com/IMG/805/22805/kirana-store-india-580x358.jpeg?1560398647",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            AutoSizeText(
              "Justin General and Kirana stores",
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
