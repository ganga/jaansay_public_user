import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/screens/community/profile_screen.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class FeedTopDetails extends StatelessWidget {
  final Feed feed;

  FeedTopDetails(this.feed);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreenWithRouteSettings(context,
            screen: ProfileScreen(),
            settings: RouteSettings(arguments: [false, feed.userId.toString()]),
            pageTransitionAnimation: PageTransitionAnimation.cupertino);
      },
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(child: CustomNetWorkImage(feed.photo)),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${feed.officialsName}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                          text: "#${feed.typeName} ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).primaryColor,
                          )),
                      TextSpan(
                        text:
                            DateFormat.yMMMd().add_jm().format(feed.updatedAt),
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
