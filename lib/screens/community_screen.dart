import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/community/community_detail_screen.dart';
import 'package:jaansay_public_user/screens/community/profile_list_screen.dart';
import 'package:jaansay_public_user/screens/community/profile_screen.dart';

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
