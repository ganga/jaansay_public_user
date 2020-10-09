import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/community/communityDetailsScreen.dart';
import 'package:jaansay_public_user/screens/community/profileListScreen.dart';
import 'package:jaansay_public_user/screens/community/profileScreen.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IndexedStack(
        index: 2,
        children: <Widget>[
          CommunityDetailsScreen(),
          ProfileListScreen(),
          ProfileScreen()
        ],
      ),
    );
  }
}
