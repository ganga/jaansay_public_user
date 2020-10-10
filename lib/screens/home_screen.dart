import 'package:flutter/material.dart';
import 'package:jaansay_public_user/utils/tab_navigator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _currentPage = 'feed';
  List<String> _pageKeys = ['feed', 'community', 'market', 'alert'];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    'feed': GlobalKey<NavigatorState>(),
    'community': GlobalKey<NavigatorState>(),
    'market': GlobalKey<NavigatorState>(),
    'alert': GlobalKey<NavigatorState>(),
  };

  selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = _pageKeys[index];
        _currentIndex = index;
      });
    }
  }

  Widget appBarIcon(IconData iconData, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Icon(
        iconData,
        size: 32,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      backgroundColor: Colors.white,
      title: Image.asset(
        "assets/images/logo.png",
        fit: BoxFit.contain,
        height: 32,
      ),
      centerTitle: true,
      actions: [
        appBarIcon(Icons.search, context),
        appBarIcon(Icons.message, context)
      ],
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "feed") {
            selectTab("feed", 0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.group), title: Text("Community")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text("MarketPlace")),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_alert), title: Text("Alert")),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedItemColor: Colors.white54,
          unselectedLabelStyle: TextStyle(color: Colors.white54),
          onTap: (val) {
            selectTab(_pageKeys[val], val);
          },
        ),
        appBar: appBar(context),
        drawer: Drawer(),
        body: Stack(children: <Widget>[
          _buildOffstageNavigator("feed"),
          _buildOffstageNavigator("community"),
          _buildOffstageNavigator("market"),
          _buildOffstageNavigator("alert"),
        ]),
      ),
    );
  }
}
