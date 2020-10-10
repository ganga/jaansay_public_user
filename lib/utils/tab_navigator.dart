import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/community_screen.dart';
import 'package:jaansay_public_user/screens/feed_screen.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == "feed")
      child = FeedScreen();
    else if (tabItem == "community")
      child = CommunityScreen();
    else if (tabItem == "market")
      child = FeedScreen();
    else {
      child = CommunityScreen();
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
