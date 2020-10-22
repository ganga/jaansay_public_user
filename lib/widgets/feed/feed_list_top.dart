import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/widgets/feed/follow_button.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';

class FeedListTop extends StatelessWidget {
  final Size mediaQuery;
  final Official official;
  final Function followUser;
  final Function rejectFollow;

  FeedListTop(
      this.mediaQuery, this.official, this.followUser, this.rejectFollow);

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
    return Container(
      color: Colors.white,
      width: mediaQuery.width,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildLeftRow(context),
          Expanded(child: Container()),
          FollowButton(true, "Accept", official, followUser),
          SizedBox(
            width: 8,
          ),
          FollowButton(false, "Reject", official, rejectFollow)
        ],
      ),
    );
  }
}
