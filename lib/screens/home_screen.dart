// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/widgets/announcement/announcement_section.dart';
import 'package:jaansay_public_user/widgets/poll/poll_section.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';


// Project imports:
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/community_detail_screen.dart';
import 'package:jaansay_public_user/screens/feed/feed_list_screen.dart';
import 'package:jaansay_public_user/screens/feed/nearby_list_screen.dart';
import 'package:jaansay_public_user/screens/misc/dashboard_screen.dart';
import 'package:jaansay_public_user/screens/misc/search_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/about_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/vocal_local_screen.dart';
import 'package:jaansay_public_user/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  bool isCheck = false;
  OfficialProfileProvider officialProfileProvider;
  Widget appBarIcon(
      IconData iconData, BuildContext context, String tag, Function onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Hero(
        tag: tag,
        child: Container(
          margin: EdgeInsets.only(right: 10, left: 10),
          child: Icon(
            iconData,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      backgroundColor: Colors.white,
      title: InkWell(
        onTap: () {
          Get.to(() => AboutScreen());
        },
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.contain,
          height: 32,
        ),
      ),
      centerTitle: true,
      actions: [
      ],
    );
  }

  List<Widget> _buildScreens() {
    return [
      PollSection(),
      AnnouncementSection(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    double iconSize = 22;

    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.poll,
        ),
        inactiveIcon: Icon(
          Icons.poll_outlined,
        ),
        title: "Surveys",
        iconSize: iconSize,
        activeColorPrimary: Get.theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.announcement,
        ),
        inactiveIcon: Icon(
          Icons.announcement_outlined,
        ),
        title: "Announcements",
        iconSize: iconSize,
        activeColorPrimary: Get.theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  fbmSubscribe() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      if (message.data['type'] == "message") {
        //pushNewScreen(context, screen: MessageScreen(), withNavBar: false);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context, listen: false);
    if (!isCheck) {
      isCheck = true;
      fbmSubscribe();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context),
      drawer: SafeArea(
        child: Drawer(
          child: CustomDrawer(),
        ),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        navBarStyle:
            NavBarStyle.simple, // Choose the nav bar style with this property.
      ),
    );
  }
}
