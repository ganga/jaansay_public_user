import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/community/officialsListScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int curIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).primaryColor,
          ),
          child: BottomNavigationBar(
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
            currentIndex: curIndex,
            selectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(color: Colors.white),
            unselectedItemColor: Colors.white54,
            unselectedLabelStyle: TextStyle(color: Colors.white54),
            onTap: (val) {
              setState(() {
                curIndex = val;
              });
            },
          ),
        ),
        appBar: appBar(context),
        drawer: Drawer(),
        body: OfficialListScreen());
  }
}
