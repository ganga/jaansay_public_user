import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class ProfileListScreen extends StatefulWidget {
  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  bool isLoad = true;

  bool isCheck = false;

  List<User> users = [];

  getData() async {
    isLoad = true;
    setState(() {});
    UserService userService = UserService();
    users = await userService.getAllUsers();
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
                PolygonBoxShadow(color: Colors.black, elevation: 1.0),
                PolygonBoxShadow(color: Colors.grey, elevation: 5.0)
              ],
              child: CustomNetWorkImage(user.photo),
            ),
          ),
          Text(user.userName)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String type = ModalRoute.of(context).settings.arguments;
    final _mediaQuery = MediaQuery.of(context).size;

    if (!isCheck) {
      isCheck = true;
      getData();
    }

    return Scaffold(
      body: isLoad
          ? Loading()
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
