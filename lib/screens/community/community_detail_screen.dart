import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/community/officials_list_screen.dart';
import 'package:jaansay_public_user/screens/community/profile_list_screen.dart';
import 'package:jaansay_public_user/service/misc_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CommunityDetailsScreen extends StatefulWidget {
  @override
  _CommunityDetailsScreenState createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  bool isLoad = true;

  bool isCheck = false;

  Map count = {};

  getData() async {
    isLoad = true;
    setState(() {});
    MiscService miscService = MiscService();
    count = await miscService.getUsersCount();
    isLoad = false;
    setState(() {});
  }

  Widget _dataBox(String number, String title, BuildContext context,
      double height, double width, Widget widget, String type) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColorDark,
      margin: EdgeInsets.only(bottom: height * 0.05),
      constraints: BoxConstraints(minHeight: 100),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            pushNewScreenWithRouteSettings(context,
                screen: widget,
                settings: RouteSettings(arguments: type),
                pageTransitionAnimation: PageTransitionAnimation.cupertino);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 32),
                ),
                AutoSizeText(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 26),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    if (!isCheck) {
      isCheck = true;
      getData();
    }
    return Scaffold(
      body: isLoad
          ? Loading()
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(horizontal: _mediaQuery.width * 0.08),
                child: Column(
                  children: [
                    SizedBox(
                      height: _mediaQuery.height * 0.03,
                    ),
                    Text(
                      "Hiriadka",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: _mediaQuery.height * 0.03,
                    ),
                    _dataBox(
                        "${count['user']}",
                        "Public Users",
                        context,
                        _mediaQuery.height,
                        _mediaQuery.width,
                        ProfileListScreen(),
                        "public"),
                    _dataBox(
                        "${count['business']}",
                        "Business",
                        context,
                        _mediaQuery.height,
                        _mediaQuery.width,
                        OfficialListScreen(),
                        "101"),
                    _dataBox(
                        "${count['entity']}",
                        "Appointed Officials and Elected Members",
                        context,
                        _mediaQuery.height,
                        _mediaQuery.width,
                        OfficialListScreen(),
                        "102"),
                    _dataBox(
                        "${count['association']}",
                        "Associations and Bodies",
                        context,
                        _mediaQuery.height,
                        _mediaQuery.width,
                        OfficialListScreen(),
                        "103"),
                  ],
                ),
              ),
            ),
    );
  }
}
