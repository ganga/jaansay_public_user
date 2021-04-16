import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_network_image.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class ProfileListScreen extends StatefulWidget {
  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  bool isLoad = true;

  bool isCheck = false;
  String districtId;

  List<User> users = [];

  getData() async {
    isLoad = true;
    setState(() {});
    users.clear();
    UserService userService = UserService();
    await userService.getAllUsers(districtId, users);
    isLoad = false;
    setState(() {});
  }

  Widget profileCard(BuildContext context, User user) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Expanded(
            child: ClipPolygon(
              sides: 6,
              borderRadius: 5.0,
              // Default 0.0 degrees
              rotate: 90.0,
              // Default 0.0 degrees
              boxShadows: [
                PolygonBoxShadow(color: Colors.grey, elevation: 5.0)
              ],
              child: CustomNetWorkImage(user.photo),
            ),
          ),
          Text(
            user.userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;
    final _mediaQuery = MediaQuery.of(context).size;
    districtId = response[1];

    if (!isCheck) {
      isCheck = true;
      getData();
    }

    return Scaffold(
      body: isLoad
          ? CustomLoading()
          : users.length == 0
              ? CustomErrorWidget(
                  title: tr("No users found"),
                  iconData: Icons.supervised_user_circle_sharp,
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: GridView.builder(
                    itemCount: users.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: _mediaQuery.width * 0.03,
                        vertical: _mediaQuery.height * 0.02),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: _mediaQuery.width * 0.03,
                        mainAxisSpacing: _mediaQuery.height * 0.02),
                    itemBuilder: (context, index) {
                      return profileCard(context, users[index]);
                    },
                  ),
                ),
    );
  }
}
