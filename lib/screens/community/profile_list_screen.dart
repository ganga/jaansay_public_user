import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class ProfileListScreen extends StatefulWidget {

  final String districtId;


  ProfileListScreen(this.districtId);

  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  bool isLoad = true;


  List<User> users = [];

  getData() async {
    isLoad = true;
    setState(() {});
    users.clear();
    UserService userService = UserService();
    await userService.getAllUsers(widget.districtId, users);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {


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
                        horizontal: Get.width * 0.03,
                        vertical: Get.height * 0.02),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: Get.width * 0.03,
                        mainAxisSpacing: Get.height * 0.02),
                    itemBuilder: (context, index) {
                      return profileCard(context, users[index]);
                    },
                  ),
                ),
    );
  }
}
