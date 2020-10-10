import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/profile/officials_profile_head.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [OfficialsProfileHead()],
        ),
      ),
    );
  }
}
