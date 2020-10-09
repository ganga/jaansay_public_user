import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/profile/officialsProfileHead.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [OfficialsProfileHead()],
      ),
    );
  }
}
