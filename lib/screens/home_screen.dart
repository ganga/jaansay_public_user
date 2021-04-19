import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/community_detail_screen.dart';
import 'package:jaansay_public_user/screens/feed/feed_list_screen.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_list_screen.dart';
import 'package:jaansay_public_user/screens/message/message_screen.dart';
import 'package:jaansay_public_user/screens/misc/dashboard_screen.dart';
import 'package:jaansay_public_user/screens/misc/search_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/about_screen.dart';
import 'package:jaansay_public_user/screens/side_navigation/vocal_local_screen.dart';
import 'package:jaansay_public_user/widgets/custom_drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController _controller = PersistentTabController();
  bool isCheck = false;
  OfficialProfileProvider officialProfileProvider;
  Widget appBarIcon(
      IconData iconData, BuildContext context, String tag, Widget screen) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        if (tag == 'search_icon') {
          officialProfileProvider.clearData(allData: true);
          Get.offAll(HomeScreen());
        }
        pushNewScreen(
          context,
          screen: screen,
          withNavBar: false,
        );
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
          Icons.search,
          context,
          'search_icon',
          SearchScreen(
            description:
                "Search businesses, officials and associations near you by entering their name",
            iconData: Icons.search,
          ),
        ),
        //appBarIcon(Icons.message, context, 'message_icon', MessageScreen()),
      ],
    );
  }

  List<Widget> _buildScreens() {
    return [
      DashboardScreen(),
      CommunityDetailsScreen(),
      FeedListScreen(),
      VocalLocalScreen(
        isHome: true,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: tr("Home"),
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.group),
        title: tr("Community"),
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.dynamic_feed_outlined),
        title: tr("Feed"),
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.record_voice_over),
        title: tr("Vocal For Local"),
        activeColorPrimary: Theme.of(context).primaryColor,
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
            NavBarStyle.style3, // Choose the nav bar style with this property.
      ),
    );
  }
}
