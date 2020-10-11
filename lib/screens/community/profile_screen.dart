import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/profile/officials_profile_head.dart';
import 'package:jaansay_public_user/widgets/profile/public_profile_head.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String type = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            type == "public" ? PublicProfileHead() : OfficialsProfileHead(type)
          ],
        ),
      ),
    );
  }
}
