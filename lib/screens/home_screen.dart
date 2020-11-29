import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/alert/alert_screen.dart';
import 'package:jaansay_public_user/screens/community/community_detail_screen.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_screen.dart';
import 'package:jaansay_public_user/screens/message/message_screen.dart';
import 'package:jaansay_public_user/screens/misc/search_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/about_screen.dart';
import 'package:jaansay_public_user/widgets/custom_drawer.dart';
import 'package:jaansay_public_user/widgets/feed/feed_list.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController _controller;

  Widget appBarIcon(
      IconData iconData, BuildContext context, String tag, Widget screen) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        pushNewScreen(context, screen: screen, withNavBar: false);
      },
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
          Get.to(AboutScreen());
        },
        child: Hero(
          tag: "mainlogo",
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        appBarIcon(Icons.search, context, 'search_icon', SearchScreen()),
        appBarIcon(Icons.message, context, 'message_icon', MessageScreen()),
      ],
    );
  }

  List<Widget> _buildScreens() {
    return [
      FeedList(),
      CommunityDetailsScreen(),
      GrievanceScreen(),
      AlertScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: tr("Home"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.group),
        title: tr("Community"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.messageAlert),
        title: tr("Grievance"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add_alert),
        title: tr("Alert"),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Colors.grey,
      ),
    ];
  }

  fbmSubscribe() {
    GetStorage box = GetStorage();
    FirebaseMessaging fbm = FirebaseMessaging();
    fbm.subscribeToTopic(box.read("user_id").toString());
    fbm.subscribeToTopic("all");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fbmSubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar(context),
      drawer: SafeArea(
        child: Drawer(
          child: CustomDrawer(),
        ),
      ),
      body: PersistentTabView(
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
            NavBarStyle.style3, // Choose the nav bar style with this property.
      ),
    );
  }
}
