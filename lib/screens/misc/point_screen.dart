// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class PointsScreen extends StatefulWidget {
  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  bool isLoad = true;
  UserService userService = UserService();
  List<UserPoint> userPoints = [];

  getPoints() async {
    await userService.getPoints(userPoints);
    isLoad = false;
    setState(() {});
  }

  pointSection(String score, String title) {
    return Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: Column(
          children: [
            Text(
              score,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.5),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12),
            )
          ],
        ));
  }

  pointItem(UserPoint userPoint) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child: CustomNetWorkImage(userPoint.photo),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userPoint.officialsName,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Text(
                      userPoint.businessTypeName,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              color: Colors.black.withOpacity(0.4),
              height: 0.5,
              width: double.infinity,
            ),
            Container(
              child: Row(
                children: [
                  pointSection(userPoint.score.toString(), "Engagement points"),
                  pointSection(userPoint.loyalty.toString(), "Loyalty points"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Your Points",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: isLoad
          ? CustomLoading(title: "Loading your points")
          : userPoints.length == 0
              ? CustomErrorWidget(
                  iconData: FontAwesomeIcons.moneyBillWave,
                  description:
                      "Follow businesses, officials and groups to gain points. Use these points to avail offers and discounts.",
                )
              : ListView.builder(
                  itemCount: userPoints.length,
                  itemBuilder: (context, index) {
                    return pointItem(userPoints[index]);
                  },
                ),
    );
  }
}
