import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/alert/alert_screen.dart';
import 'package:jaansay_public_user/screens/community/community_detail_screen.dart';
import 'package:jaansay_public_user/screens/feed_screen.dart';
import 'package:jaansay_public_user/screens/market/market_screen.dart';

class TabNavigatorRoutes {
  static const String root = '/';
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
      child = CommunityDetailsScreen();
    else if (tabItem == "market")
      child = MarketScreen();
    else {
      child = AlertScreen();
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
