// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/widgets/poll/poll_secction.dart';
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
      PersistentTabController(initialIndex: 2);
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
        appBarIcon(
          Icons.qr_code,
          context,
          'qr_code',
          () {
            Get.dialog(
              AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      GetStorage().read("user_name").toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.65),
                          letterSpacing: 0.45),
                    ),
                    Text(
                      "JaanSay Contact",
                      style: TextStyle(
                          fontSize: 11, color: Get.theme.primaryColor),
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      alignment: Alignment.center,
                      child: QrImage(
                        data: json.encode({
                          "type": "profile",
                          "user_id": GetStorage().read("user_id").toString(),
                          "code": null
                        }),
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        appBarIcon(
          Icons.search,
          context,
          'search_icon',
          () {
            pushNewScreen(
              context,
              screen: SearchScreen(
                description:
                    "Search businesses, officials and associations near you by entering their name",
                iconData: Icons.search,
              ),
              withNavBar: false,
            );
          },
        ),
        //appBarIcon(Icons.message, context, 'message_icon', MessageScreen()),
      ],
    );
  }

  List<Widget> _buildScreens() {
    return [
      FeedListScreen(),
      NearbyListScreen(),
      PollSection(),
      CommunityDetailsScreen(),
      VocalLocalScreen(
        isHome: true,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    double iconSize = 22;

    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.photo,
        ),
        inactiveIcon: Icon(
          Icons.photo_outlined,
        ),
        title: tr("Feed"),
        iconSize: iconSize,
        activeColorPrimary: Get.theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.place,
        ),
        inactiveIcon: Icon(
          Icons.place_outlined,
        ),
        title: tr("Nearby"),
        iconSize: iconSize,
        activeColorPrimary: Get.theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.dashboard,
        ),
        inactiveIcon: Icon(
          Icons.dashboard_outlined,
        ),
        title: tr("Dashboard"),
        iconSize: iconSize,
        activeColorPrimary: Get.theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.group_work_rounded,
        ),
        inactiveIcon: Icon(
          Icons.group_work_outlined,
        ),
        title: tr("Community"),
        iconSize: iconSize,
        activeColorPrimary: Get.theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.record_voice_over,
        ),
        inactiveIcon: Icon(
          Icons.record_voice_over_outlined,
        ),
        title: tr("Vocal For Local"),
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
            NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
    );
  }
}
