import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.8),
                children: <TextSpan>[
                  TextSpan(text: 'You earned '),
                  TextSpan(
                      text: userPoint.score.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Theme.of(context).primaryColor)),
                  TextSpan(text: ' points.'),
                ],
              ),
            ),
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
