import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/login_signup/custom_auth_button.dart';
import 'package:jaansay_public_user/widgets/misc/official_tile.dart';

class FollowScreen extends StatefulWidget {
  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  bool isLoad = true;
  List<Official> officials = [];

  getData() async {
    OfficialService officialService = OfficialService();
    officials = await officialService.getAllOfficials();
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Widget appBar(BuildContext context) {
    return AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Follow users near you",
          style: TextStyle(color: Get.theme.primaryColor),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Column(
        children: [
          isLoad
              ? Loading()
              : Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: officials.length,
                      itemBuilder: (context, index) {
                        return OfficialTile(officials[index]);
                      },
                    ),
                  ),
                ),
          CustomAuthButton(
            title: "Continue",
            onTap: () => Get.offAll(HomeScreen()),
          ),
        ],
      ),
    );
  }
}
