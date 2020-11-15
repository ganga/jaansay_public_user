import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/widgets/feed/follow_button.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:provider/provider.dart';

class FeedListTop extends StatelessWidget {
  final Official official;

  FeedListTop(this.official);

  Row buildLeftRow(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(child: CustomNetWorkImage(official.photo)),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${official.officialsName}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              "#${official.businesstypeName}",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<UserFeedProvider>(context);

    return Container(
      color: Colors.white,
      width: Get.width,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildLeftRow(context),
          Expanded(child: Container()),
          FollowButton(true, "Accept", feedProvider.acceptFollow(official)),
          SizedBox(
            width: 8,
          ),
          FollowButton(false, "Reject", feedProvider.rejectFollow(official))
        ],
      ),
    );
  }
}
